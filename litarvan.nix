{ pkgs, ... }:

{
  description = "Adrien Navratil";
  isNormalUser = true;
  createHome = true;
  extraGroups = [ "wheel" "adbusers" "arangodb" ];
  shell = pkgs.fish;
}

# Don't forget to passwd
