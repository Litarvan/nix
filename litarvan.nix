{ pkgs, ... }:

{
  description = "Adrien Navratil";
  isNormalUser = true;
  extraGroups = [ "wheel" "docker" ];
  shell = pkgs.fish;
  openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInaniB1BxOLjf63vH8+LJ8L51j0kZqbEQhl0QYiIibs" ];
}

# Don't forget to passwd
