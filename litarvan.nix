{ pkgs, ... }:

{
  description = "Adrien Navratil";
  isNormalUser = true;
  createHome = true;
  extraGroups = [ "wheel" "adbusers" "docker" ];
  shell = pkgs.fish;
}

# Don't forget to passwd
