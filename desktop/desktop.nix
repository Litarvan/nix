{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "installer/scan/not-detected.nix")
    ../arangodb.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.printing.enable = true;
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

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
    adb.enable = true;
    steam.enable = true;
  };

  virtualisation.virtualbox.host.enable = true;
  environment.systemPackages = with pkgs; [ firefox ];

  users.users.litarvan.extraGroups = [ "adbusers" "arangodb" "vboxusers" ];
}
