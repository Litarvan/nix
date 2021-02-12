import ./service.nix ({ lib, pkgs }:

{
  name = "epilink";
  description = "EpiLink backend server and Discord bot";

  package = pkgs.callPackage ../programs/epilink.nix {};
  command = "bin/epilink-backend";

  args = cfg: pkgs.writeText "epilink.yml" (lib.replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg.config));

  options = {
    config = lib.mkOption {
      type = (pkgs.formats.yaml {}).type;
      default = {};
      description = "EpiLink configuration";
    };
  };
})
