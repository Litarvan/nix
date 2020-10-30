{ config, pkgs, ... }:

{
  imports = [
    ./local.nix # See local.example.nix
    ./arangodb.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  console = {
    keyMap = "fr";
    font = "Lat2-Terminus16";
  };

  i18n.defaultLocale = "fr_FR.UTF-8";
  time.timeZone = "Europe/Paris";

  services.printing.enable = true;
  sound.enable = true;

  services.xserver = {
    enable = true;

    layout = "fr";
    xkbOptions = "eurosign:e";

    libinput.enable = true;

    displayManager.lightdm.enable = true;
  };

  services.geoclue2.enable = true;
  services.arangodb.enable = true;

  programs = {
    fish.enable = true;
    adb.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [ git firefox ];

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  users = {
    users.litarvan = import ./litarvan.nix { inherit pkgs; };
    extraGroups.vboxusers.members = [ "litarvan" ];
  };

  nixpkgs.config.allowUnfree = true;
}
