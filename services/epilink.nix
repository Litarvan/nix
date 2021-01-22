{ config, lib, pkgs, ... }:

with pkgs lib;

callPackage (import ./service.nix {
  name = "epilink";
  description = "EpiLink backend server and Discord bot";

  package = import ../programs/epilink.nix;
  command = "bin/epilink-backend";

  args = cfg: writeText "epilink.yml" (replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON (
    ({ db = "${cfg.dataDir}/epilink.db"; }) // cfg.config
  )));

  options = {
    config = mkOption {
      type = (formats.yaml {}).type;
      default = {};
      description = "EpiLink configuration";
    };
  };
}) {}
