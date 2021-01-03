{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.epilink;
  yamlFormat = pkgs.formats.yaml {};

  configFile = pkgs.writeText "epilink.yml" (replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg.config));
in

{

  ###### interface

  options = {
    services.epilink = {
      enable = mkEnableOption "EpiLink backend server and Discord bot";

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/epilink";
        description = "EpiLink data directory";
      };
      
      config = mkOption {
        type = yamlFormat.type;
        default = {};
        description = "EpiLink configuration";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    users = {
      users.epilink.group = "epilink";
      groups.epilink = {};
    };

    systemd.services.epilink = rec {
      description = "EpiLink backend server and Discord bot";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${callPackage ../programs/epilink.nix}/bin/epilink-backend ${configFile}";
        User = "epilink";
        Group = "epilink";
        PermissionsStartOnly = true;
        WorkingDirectory = "${cfg.dataDir}";
      };

      preStart = ''
        install -d -m0700 -o ${escapeShellArg serviceConfig.User} -g ${escapeShellArg serviceConfig.Group} ${escapeShellArg cfg.dataDir}

        # just in case of uid/gid change
        chown -R ${escapeShellArg "${serviceConfig.User}:${serviceConfig.Group}"} ${escapeShellArg cfg.dataDir}
      '';
    };
  };
}
