{ ... }:

{
  imports = [ ../server.nix ];

  boot.loader.grub.device = "/dev/vda";

  fileSystems."/" = {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  networking = {
    hostName = "sydkilin";

    firewall = {
      allowedTCPPorts = [ 80 443 2350 3450 ];
      allowedUDPPorts = [ 2350 3450 ];
    };

    defaultGateway = "45.90.162.65";

    interfaces.eth0 = {
      ipv4.addresses = [ { address = "45.90.162.86"; prefixLength = 27; } ];
      ipv6.addresses = [ { address = "2a0c:b642:4001:7:78bc:92ff:fe88:ccda"; prefixLength = 64; } ];
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="7a:bc:92:88:cc:da", NAME="eth0"
  '';
}
