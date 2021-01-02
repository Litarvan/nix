{ lib, modulesPath, ... }:

{
  imports = [ ./ ];

  boot.loader.grub.device = "/dev/vda";

  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  networking = {
    defaultGateway = "45.90.162.65";
    defaultGateway6 = "fe80::921b:eff:fe0b:186";

    interfaces.eth0 = {
      ipv4 = {
        addresses = [ { address = "45.90.162.86"; prefixLength = 27; } ];
        routes = [ { address = "45.90.162.65"; prefixLength = 32; } ];
      };

      ipv6 = {
        addresses = [
          { address = "2a0c:b642:4001:7:78bc:92ff:fe88:ccda"; prefixLength = 64; }
          { address = "fe80::78bc:92ff:fe88:ccda"; prefixLength = 64; }
        ];
        routes = [ { address = "fe80::921b:eff:fe0b:186"; prefixLength = 32; } ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="7a:bc:92:88:cc:da", NAME="eth0"
  '';
}
