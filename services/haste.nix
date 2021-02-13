import ./service.nix ({ lib, pkgs }:

{
  name = "haste-server";
  description = "Hastebin HTTP server";

  package = callPackage ../programs/haste;
})
