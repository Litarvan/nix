{ pkgs, lib, config, ... }:

{
  imports = [ ./desktop.nix ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [ r8125 ];

    loader = {
      efi = {
          efiSysMountPoint = "/efi";
          canTouchEfiVariables = true;
      };

      systemd-boot.enable = true;
    };
  };

  networking = {
    hostName = "arkilin";

    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
  };

  hardware = {
    opengl.extraPackages = with pkgs; [ amdvlk ];
    video.hidpi.enable = true;
  };

  services.xserver = {
    desktopManager.plasma5.enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/45d50d1e-97e6-4e70-8812-f1e6f1b91407";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/0832c528-687a-4d1b-9e8e-b2223cae86cb";
      fsType = "ext4";
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/5778-5A12";
      fsType = "vfat";
    };
  };


  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  environment.systemPackages = with pkgs; [ plasma-browser-integration ];
}
