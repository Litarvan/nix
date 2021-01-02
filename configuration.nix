{ config, pkgs, ... }:

{
  imports = [
    ./local.nix # See local.example.nix
  ];

  console = {
    keyMap = "fr";
    font = "Lat2-Terminus16";
  };

  i18n.defaultLocale = "fr_FR.UTF-8";
  time.timeZone = "Europe/Paris";

  users.users.litarvan = import ./litarvan.nix { inherit pkgs; };

  programs.fish.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [ git firefox ];

  nixpkgs.config.allowUnfree = true;
}
