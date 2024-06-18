{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
  let
    # darwin-rebuild switch --flake ~/dot --impure
    userConfig = (import (if builtins.pathExists "/etc/nix/user-config.nix"
      then "/etc/nix/user-config.nix"
      else ./user-config.nix)
    );

    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      system.defaults = {
        dock.autohide = true;  # this requires logout/login
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = userConfig.hostPlatform;

      users.users.${userConfig.username} = {
        name = userConfig.username;
        home = userConfig.homeDirectory;
      };

      # enables unlocking sudo using touch id (only locally, not remotely)
      security.pam.enableSudoTouchIdAuth = true;

      # Install fonts
      # unused and disallowed on nix-darwin
      # fonts.fontDir.enable = true;
      fonts.packages = with pkgs; [
        fira-code
        fira-code-nerdfont
      ];

    };
  in
  {
  } // (
    if nixpkgs.legacyPackages.${userConfig.hostPlatform}.pkgs.stdenv.isDarwin then {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#<yourLocalHostName>
      darwinConfigurations.${userConfig.localHostName} = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userConfig.username} = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${userConfig.localHostName}.pkgs;
    } else {
    }
  );
}
