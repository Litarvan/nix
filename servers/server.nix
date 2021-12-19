{ pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # Breaks too much things
    # (modulesPath + "/profiles/hardened.nix")

    ./nginx.nix
  ];

  boot = {
    loader.grub.splashImage = null;

    # Way too old
    # kernelPackages = pkgs.linuxPackages_latest_hardened;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "xt_nat" ];
    kernelParams = [ "panic=1" "boot.panic_on_fail" ];

    vesa = false;
    cleanTmpDir = true;
  };

  networking = {
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;

    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eth0";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 18982 ];
    permitRootLogin = "no";
    passwordAuthentication = false;
    # forwardX11 = true;
  };

  # programs.ssh = {
  #   forwardX11 = true;
  #   setXAuthLocation = true;
  # };

  environment = {
    # Prevents dovecot2 from working :/
    # memoryAllocator.provider = "graphene-hardened";
    # memoryAllocator.provider = "libc";
    # noXlibs = lib.mkForce true;
  };
}
