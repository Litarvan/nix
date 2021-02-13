import ./service.nix ({ lib, pkgs }:

{
  name = "haste-server";
  description = "Hastebin HTTP server";

  package = pkgs.callPackage ../programs/haste {};
})
