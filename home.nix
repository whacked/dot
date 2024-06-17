{ config, pkgs, lib, ... }:

let
  myConfig = (import ~/setup/nix/config.nix) { inherit pkgs; };
  # YOU MUST CREATE THIS! example:
  # {
  #   username = "fooser";
  #   homeDirectory = "/Users/barser";  # <-- optional, fallback to /home/$username
  #   git = {
  #     userName = "git-user-name";
  #     userEmail = "gituser@users.noreply.example.com";
  #   };
  # }
  userConfig = (import ./user-config.nix);
  userHomeDirectory = if builtins.hasAttr "homeDirectory" userConfig
    then userConfig.homeDirectory
    else "/home/${userConfig.username}";

  makeSubstitutedFile = { srcName, substitutions }:
    pkgs.substituteAll ({
      src = /. + builtins.toPath "${userHomeDirectory}/dot/${srcName}";
    } // substitutions);

  makeSymlink = srcName:
    config.lib.file.mkOutOfStoreSymlink (/. + builtins.toPath "${userHomeDirectory}/dot/${srcName}");
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  home.packages = [
  ]
  ++ myConfig.includeDefaultPackages
  ++ myConfig.includeUnfreePackages
  ;

  # export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
  home.sessionVariables.LOCALES_ARCHIVE = (
    if pkgs.stdenv.isLinux then (
      "${pkgs.glibcLocales}/lib/locale/locale-archive"
    ) else null
  );

  home.username = userConfig.username;
  home.homeDirectory = userHomeDirectory;

  home.file = {

    ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

    ".bashrc".source = makeSubstitutedFile {
      srcName = "bashrc";
      substitutions = {
        minioPath = "${pkgs.minio-client}/bin/mc";
      };
    };
    ".config/kitty/kitty.conf".source = makeSubstitutedFile {
      srcName = "kitty.conf";
      substitutions = {
        shellPath = "${pkgs.zsh}/bin/zsh";
      };
    };
    ".config/tmux.conf".source = makeSymlink "tmux.conf";
    ".emacs.d".source = makeSymlink "emacs.d";
    ".gitconfig".source = makeSubstitutedFile {
      srcName = "gitconfig";
      substitutions = {
        deltaPath = "${pkgs.delta}/bin/delta";
        userName = "${userConfig.git.userName}";
        userEmail = "${userConfig.git.userEmail}";
      };
    };
    ".lein".source = makeSymlink "lein";
    ".Rprofile".source = makeSymlink "Rprofile";
    ".vim".source = makeSymlink "vim";
    ".vimrc".source = makeSymlink "vimrc";
    ".zsh".source = makeSymlink "zsh";
    ".zshrc".source = makeSubstitutedFile {
      srcName = "zshrc";
      substitutions = {
        minioPath = "${pkgs.minio-client}/bin/mc";
      };
    };

    # haven't used these in a long time
    # ".boot.profile".source = makeSymlink "boot.profile";
    # ".subversion".source = makeSymlink "subversion";

  } // (
    lib.optionalAttrs pkgs.stdenv.isLinux
    {
      ".config/i3/config".source = makeSubstitutedFile {
        srcName = "i3/config";
        substitutions = {
          fileManagerPath = "${pkgs.cinnamon.nemo}/bin/nemo";
        };
      };
    }
  );

}

