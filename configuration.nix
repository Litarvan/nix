{ pkgs, ... }:

{
  imports = [
    ./local # See local/default.example.nix

    ./services/arangodb.nix
    ./services/endlessh.nix
    ./services/epilink.nix
    ./services/haste.nix
    ./services/shenron.nix
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

  environment.systemPackages = with pkgs; [ vim git ];

  nixpkgs.config.allowUnfree = true;
}
