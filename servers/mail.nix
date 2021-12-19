{ mainDomain, domains, accounts }:

{ config, pkgs, ... }:
{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.11/nixos-mailserver-nixos-21.11.tar.gz";
      sha256 = "1i56llz037x416bw698v8j6arvv622qc0vsycd20lx3yx8n77n44";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = mainDomain;
    domains = domains;
    loginAccounts = accounts;

    certificateScheme = 3;
  };
}
