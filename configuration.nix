{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Excluded from git
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "archimede";
    wireless.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # TODO: Move that section home ?
  services.xserver.enable = true;
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";

  services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  programs.fish.enable = true; # Is this needed ? Move to home maybe ? 

  users.users.litarvan = import ./litarvan.nix { inherit pkgs; };

  system.stateVersion = "19.03";
}
