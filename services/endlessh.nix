import ./service.nix ({ lib, pkgs }:

{
  name = "endlessh";
  description = "Endlessh server";

  package = pkgs.endlessh;
})
