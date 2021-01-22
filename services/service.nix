{ name, description, package, command, args, options ? {} }:
{ config, lib, ... }:

with lib;

let
  cfg = config.services."${name}";
  desc = description;
  opts = options;
in
{

  ###### interface

  options = {
    services."${name}" = {
      enable = mkEnableOption "Enable ${desc}";
      dataDir = mkOption {
        type = types.path;
        default = "/var/db/${name}";
        description = "Service data directory";
      };
    } // opts;
  };

  ###### implementation

  config = mkIf cfg.enable {
    users = {
      users."${name}".group = name;
      groups."${name}" = {};
    };

    systemd.services."${name}" = rec {
      description = desc;

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${package}/${command} ${args cfg}";
        User = name;
        Group = name;
        PermissionsStartOnly = true;
        WorkingDirectory = "${package}";
      };

      preStart = ''
        install -d -m0700 -o ${escapeShellArg serviceConfig.User} -g ${escapeShellArg serviceConfig.Group} ${escapeShellArg cfg.dataDir}

        # just in case of uid/gid change
        chown -R ${escapeShellArg "${serviceConfig.User}:${serviceConfig.Group}"} ${escapeShellArg (cfg.dataDir)}
      '';
    };
  };
}
