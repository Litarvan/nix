import ./service.nix ({ lib, pkgs }:

{
  name = "epilink";
  description = "EpiLink backend server and Discord bot";

  package = pkgs.callPackage ../programs/epilink.nix {};
  command = "bin/epilink-backend";

  args = cfg: "config/epilink.yml";
})
