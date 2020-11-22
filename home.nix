{ config, pkgs, ... }:

let
  myconfig = (import ~/setup/nix/config.nix);
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.packages = [
  ]
  ++ myconfig.includeDefaultPackages
  ++ myconfig.includeUnfreePackages
  ;

  home.sessionVariables.LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  # export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
}

