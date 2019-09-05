{ pkgs, ... }:

{
  description = "Adrien Navratil";
  isNormalUser = true;
  createHome = true;
  extraGroups = [ "wheel" ];
  shell = pkgs.fish;
}

# Don't forget to passwd
