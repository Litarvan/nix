import ./service.nix ({ lib, pkgs }:

{
  name = "shenron";
  description = "General purpose Discord bot";

  package = pkgs.callPackage ../programs/shenron.nix {};
  command = "bin/shenron";

  args = cfg: cfg.token;

  options = {
    token = lib.mkOption {
      type = lib.types.string;
      default = "";
      description = "Discord bot token";
    };
  };
})
