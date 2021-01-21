{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../services/arangodb.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services = {
    printing.enable = true;

    xserver = {
      enable = true;

      layout = "fr";
      xkbOptions = "eurosign:e";

      libinput.enable = true;

      displayManager.lightdm.enable = true;
    };

    geoclue2.enable = true;
    arangodb.enable = true;
  };

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  # Broken on latest kernel
  # virtualisation.virtualbox.host.enable = true;

  environment.systemPackages = with pkgs; [ firefox ];

  users.users.litarvan.extraGroups = [ "adbusers" "arangodb" ]; # "vboxusers"
}
