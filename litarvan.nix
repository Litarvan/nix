{ pkgs, ... }:

{
  description = "Adrien Navratil";
  isNormalUser = true;
  createHome = true;
  extraGroups = [ "wheel" "adbusers" "docker" "arangodb" ];
  shell = pkgs.fish;
}

# Don't forget to passwd
