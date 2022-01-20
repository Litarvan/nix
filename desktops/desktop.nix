{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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

      displayManager.gdm.enable = true;
    };

    geoclue2.enable = true;
  };

  programs.steam.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.users.litarvan.extraGroups = [ "vboxusers" ];

  environment.systemPackages = with pkgs; [ firefox ];
}
