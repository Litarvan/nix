import ./service.nix ({ lib, pkgs }:

{
  name = "endlessh";
  description = "SSH bot hell";

  package = pkgs.endlessh;
})
