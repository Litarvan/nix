{ pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];

    loader = {
      efi.efiSysMountPoint = "/boot";

      grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
      };
    };
  };

  networking = {
    hostName = "arkilin";
    wireless.enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    opengl.driSupport32Bit = true;
  };

  services.xserver = {
    desktopManager.plasma5.enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c1669841-c7eb-4741-9531-38d83c06dbc3";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };
  };
}
