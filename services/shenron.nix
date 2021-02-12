import ./service.nix ({ lib, pkgs }:

{
  name = "shenron";
  description = "Shenron Discord bot";

  package = pkgs.callPackage ../programs/shenron.nix {};
  command = "bin/shenron";

  args = cfg: "$(${pkgs.coreutils}/bin/cat ./token)";
})
