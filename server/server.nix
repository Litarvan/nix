{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/hardened.nix")
  ];

  boot = {
    loader.grub.splashImage = null;

    kernelPackages = pkgs.linuxPackages_latest_hardened;
    kernelParams = [ "panic=1" "boot.panic_on_fail" ];

    vesa = false;
  };

  networking = {
      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;

      nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  environment = {
    memoryAllocator.provider = "graphene-hardened";
    noXlibs = true;
  };
}
