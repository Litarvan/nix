{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Excluded from git
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "kilin"; # TODO: Move in separate host-dependent configuration
    #wireless.enable = true; # TODO: Same
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

  # TODO: Programs section
  programs.fish.enable = true; # Is this needed ? Move to home maybe ? 
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [ git ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "litarvan" ];

  users.users.litarvan = import ./litarvan.nix { inherit pkgs; };

  # TODO: Hardware dependent too
  hardware = {
    bluetooth.enable = true;

    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    nvidia.optimus_prime = {
      enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    opengl.driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "19.03";
}
