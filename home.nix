{ config, pkgs, lib, ... }:

let
  /**
  # YOU MUST CREATE ./user-config.nix
  # see ./user-config.nix.example
  */
  userConfig = (import (if builtins.pathExists "/etc/nix/user-config.nix"
    then "/etc/nix/user-config.nix"
    else ./user-config.nix)
  );

  myConfig = (import ~/setup/nix/config.nix) { inherit pkgs; };
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
    pkgs.zsh
  ]
  ++ myConfig.includeDefaultPackages
  ++ (if (userConfig.includeUnfree or false) then
    myConfig.includeUnfreePackages
    else [])
  ++ [
    (pkgs.writeShellScriptBin "midnight-commander" "${pkgs.mc}/bin/mc $*")
    (pkgs.writeShellScriptBin "minioc" "${pkgs.minio-client}/bin/mc $*")
  ]
  ;

  programs.zsh = {
    enable = true;
    # this is overridden by .zshrc symlink
    # plugins = [ ];
    oh-my-zsh = {
      enable = true;
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  home.username = userConfig.username;
  home.homeDirectory = userHomeDirectory;
  home.sessionVariables = {
    ZSH_PLUGINS_SOURCES = lib.concatStringsSep " " [
      (pkgs.callPackage (import (/. + builtins.toPath "${userHomeDirectory}/setup/nix/pkgs/shells/zsh-histdb/default.nix")) {})

      # "${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
      "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
    ];
  } // (
    lib.optionalAttrs pkgs.stdenv.isLinux
    {
      ### export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
      LOCALES_ARCHIVE = (
        if pkgs.stdenv.isLinux then (
          "${pkgs.glibcLocales}/lib/locale/locale-archive"
        ) else null
      );
    }
  );

  home.activation = (if pkgs.stdenv.isLinux then {
    xset = lib.hm.dag.entryAfter ["xserver"] ''
      # disable screen blank and screen off
      ${pkgs.xorg.xset}/bin/xset s off
      ${pkgs.xorg.xset}/bin/xset s noblank
      ${pkgs.xorg.xset}/bin/xset r rate 200 30
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 160
      EOF
    '';
  } else {

  });

  home.file = {

    ".bashrc".source = makeSymlink "bashrc";
    ".config/fcitx5".source = makeSymlink "fcitx5";
    ".config/kitty/kitty.conf".source = makeSubstitutedFile {
      srcName = "kitty.conf";
      substitutions = {
        shellPath = "${pkgs.zsh}/bin/zsh";
      };
    };
    ".config/nvim".source = makeSymlink "vim";
    ".config/tmux/tmux.conf".source = makeSymlink "tmux.conf";
    ".config/wezterm/wezterm.lua".source = makeSymlink "wezterm/wezterm.lua";
    ".config/zellij/config.kdl".source = makeSymlink "zellij/config.kdl";
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
    ".zshrc".source = makeSymlink "zshrc";

    # haven't used these in a long time
    # ".boot.profile".source = makeSymlink "boot.profile";
    # ".subversion".source = makeSymlink "subversion";

  } // (
    lib.optionalAttrs pkgs.stdenv.isLinux
    {
      ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      ".config/i3/config".source = makeSymlink "i3/config";
    }
  );

}

