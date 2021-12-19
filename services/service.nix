params: { config, lib, pkgs, ... }: ({ name, description, package, command ? "", args ? cfg: "", options ? {} }:

let
  cfg = config.services."${name}";
  desc = description;
  opts = options;
  cmd = if command == "" then "bin/${name}" else command;
in
with lib; {

  ###### interface

  options = {
    services."${name}" = {
      enable = mkEnableOption "Enable ${desc}";
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = "Service data directory";
      };
    } // opts;
  };

  ###### implementation

  config = mkIf cfg.enable {
    users = {
      users."${name}" = {
        group = name;
        isSystemUser = true;
      };
      groups."${name}" = {};
    };

    systemd.services."${name}" = rec {
      description = desc;

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/sh -c 'cd ${cfg.dataDir}; exec ${package}/${cmd} ${args cfg}'";
        User = name;
        Group = name;
        Restart = "on-failure";
        RestartSec = "5s";
        PermissionsStartOnly = true;
      };

      preStart = ''
        install -d -m0700 -o ${escapeShellArg serviceConfig.User} -g ${escapeShellArg serviceConfig.Group} ${escapeShellArg cfg.dataDir}

        # just in case of uid/gid change
        chown -R ${escapeShellArg "${serviceConfig.User}:${serviceConfig.Group}"} ${escapeShellArg (cfg.dataDir)}
      '';
    };
  };
}

) (params { inherit lib pkgs; })
