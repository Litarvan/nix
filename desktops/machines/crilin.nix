{ pkgs, lib, ... }:

{
  imports = [ ../desktop.nix ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" "dm-mod" "dm-cache" "dm-cache-smq" "dm-thin-pool" "dm-raid" "raid1" "dm-crypt" ];

      extraUtilsCommands = ''
        for BIN in ${pkgs.thin-provisioning-tools}/{s,}bin/*; do
            copy_bin_and_libs $BIN
        done
      '';
      preLVMCommands = ''
        mkdir -p /etc/lvm
        echo "global/thin_check_executable = "$(which thin_check)"" >> /etc/lvm/lvm.conf
        echo "global/cache_check_executable = "$(which cache_check)"" >> /etc/lvm/lvm.conf
        echo "global/cache_dump_executable = "$(which cache_dump)"" >> /etc/lvm/lvm.conf
        echo "global/cache_repair_executable = "$(which cache_repair)"" >> /etc/lvm/lvm.conf
        echo "global/thin_dump_executable = "$(which thin_dump)"" >> /etc/lvm/lvm.conf
        echo "global/thin_repair_executable = "$(which thin_repair)"" >> /etc/lvm/lvm.conf
      '';

      luks.devices.cryptlvm = {
        device = "/dev/Main/disks";
        preLVM = false;
      };
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "crilin";
    interfaces = {
      eth0.useDHCP = true;
      eth1.useDHCP = true;
    };
  };

  services = {
    lvm.boot.thin.enable = true;

    xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    pcscd.enable = true;
    udev.packages = with pkgs; [ yubikey-personalization ]; 
  };

  programs.dconf.enable = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/20f004d7-a8f1-4f95-aaaa-da77b357d0e6";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C697-E7CB";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d0f07574-ec5f-40dd-a115-91871484ebcb";
      fsType = "ext4";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/20768fae-b9de-4c5c-b722-f11275e3ae50";
      fsType = "ext4";
    };
  };
}
