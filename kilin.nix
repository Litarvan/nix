{ pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
  };

  networking.hostName = "kilin";

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

  services.xserver.videoDrivers = [ "nvidia" ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8049cda4-3de6-488f-9378-7012b749e051";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/72C5-6AA1";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/98638be3-910c-4ef2-8bfc-a4f65c247f4b";
      fsType = "ext4";
    };

    "/var" = {
      device = "/dev/disk/by-uuid/20ae3687-61a8-45fe-87aa-456d320322ab";
      fsType = "ext4";
    };

    "/opt" = {
      device = "/dev/disk/by-uuid/d08e1fae-4e22-403b-b51b-56e7cb389beb";
      fsType = "ext4";
    };

  # "/mnt/cle" = {
  #   device = "/dev/disk/by-uuid/7A820A337AC4B45D";
  #   fsType = "ntfs";
  #   options = [ "rw" "uid=1000" ];
  # };

    "/mnt/windows" = {
      device = "/dev/disk/by-uuid/26B2C6A6B2C679B7";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/4825de35-2cc2-4ce8-8290-d960d013d5f6";
    }
  ];
}
