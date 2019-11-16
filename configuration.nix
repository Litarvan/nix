{ config, pkgs, ... }:

{
  imports = [
    ./local.nix # See local.example.nix
    ./arangodb.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  }; 

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  services.printing.enable = true;
  sound.enable = true;

  # TODO: Move that section home ?
  services.xserver = {
    enable = true;

    layout = "fr";
    xkbOptions = "eurosign:e";
    videoDrivers = [ "nvidia" ];

    libinput.enable = true;

    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  programs = {
    fish.enable = true; # TODO: Is this needed ? Move to home maybe
    adb.enable = true;
  };

  environment.systemPackages = with pkgs; [ git ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "litarvan" ];

  users.users.litarvan = import ./litarvan.nix { inherit pkgs; };

  services.arangodb.enable = true;

  nixpkgs.config.allowUnfree = true;
}
