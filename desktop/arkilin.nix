{ pkgs, lib, config, ... }:

{
  imports = [ ./ ];

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

  networking.hostName = "arkilin";

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
      device = "/dev/disk/by-uuid/e4274476-758a-4157-9b46-2030f319e01d";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/21913d8e-e72c-4c1e-b50a-347b3444a367";
      fsType = "ext4";
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/73BC-4ABD";
      fsType = "vfat";
    };
  };


  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  environment.systemPackages = with pkgs; [ plasma-browser-integration ];
}
