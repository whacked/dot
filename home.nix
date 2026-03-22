{ config, pkgs, lib, inputs, ... }:

let
  /**
  # YOU MUST CREATE ./user-config.nix
  # see ./user-config.nix.example
  */
  userConfig = (import (if builtins.pathExists "/etc/nix/user-config.nix"
    then "/etc/nix/user-config.nix"
    else ./user-config.nix)
  );

  myConfig = (import ~/setup/nix/config.nix) { inherit pkgs inputs; };
  userHomeDirectory = if builtins.hasAttr "homeDirectory" userConfig
    then userConfig.homeDirectory
    else "/home/${userConfig.username}";

  makeSubstitutedFile = { srcName, substitutions }:
    pkgs.replaceVars
      (/. + builtins.toPath "${userHomeDirectory}/dot/${srcName}")
      substitutions;

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
    # note: we are NOT doing the programs.zsh as suggested elsewhere
    # in order to use makeSymlink to symlink dotfiles from ~/dot into
    # the home-manager generated store, so that we can quickly edit
    pkgs.zsh
    pkgs.oh-my-zsh
  ]
  ++ myConfig.includeDefaultPackages
  ++ (if (userConfig.includeUnfree or false) then
    myConfig.includeUnfreePackages
    else [])
  ++ [
    pkgs.sarasa-gothic  # Sarasa Mono J: monospace with built-in 2:1 CJK/ASCII ratio
    (pkgs.writeShellScriptBin "midnight-commander" "${pkgs.mc}/bin/mc $*")
    (pkgs.writeShellScriptBin "minioc" "${pkgs.minio-client}/bin/mc $*")
  ]
  ;

  programs.rofi = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc ];
  };

  i18n.inputMethod = lib.mkIf pkgs.stdenv.isLinux {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  home.username = userConfig.username;
  home.homeDirectory = userHomeDirectory;
  home.sessionVariables = {
    # oh-my-zsh: zshrc does `: ${ZSH:=~/.oh-my-zsh}` so pre-setting ZSH here
    # points it at the nix store without changing the zshrc.
    ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";

    # zsh plugins sourced by zshrc's ZSH_PLUGINS_SOURCES loop.
    # zsh-autocomplete omitted (conflicts with fzf/atuin completion).
    ZSH_PLUGINS_SOURCES = lib.concatStringsSep " " [
      "${pkgs.zsh-histdb}/share/zsh-histdb/sqlite-history.zsh"
      "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
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
      ${pkgs.xset}/bin/xset s off
      ${pkgs.xset}/bin/xset s noblank
      ${pkgs.xset}/bin/xset r rate 200 30
      ${pkgs.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 160
      EOF
    '';
  } else {

  });

  home.file = {

    ".bashrc".source = makeSymlink "bashrc";
    ".config/ghostty/config".source = makeSymlink "ghostty/config";
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
    ".zshenv".source = makeSymlink "zshenv";
    ".zshrc".source = makeSymlink "zshrc";

    # haven't used these in a long time
    # ".boot.profile".source = makeSymlink "boot.profile";
    # ".subversion".source = makeSymlink "subversion";

  } // (
    lib.optionalAttrs pkgs.stdenv.isLinux
    {
      ".config/fcitx5".source = makeSymlink "fcitx5";
      ".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      ".config/i3/config".source = makeSymlink "i3/config";
    }
  );

}

