{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.arangodb;

  writeConfFile = filename: attrs: pkgs.writeText filename (
    concatStringsSep "\n" (mapAttrsToList (section: attrs2: ''
      [${section}]
      ${concatStringsSep "\n" (mapAttrsToList (k: v: "${k} = ${if builtins.isBool v then boolToString v else toString v}") attrs2)}
    '') attrs
  ));
in

{

  ###### interface

  options = {
    services.arangodb = {
      enable = mkEnableOption "ArangoDB server";

      package = mkOption {
        default = pkgs.arangodb;
        type = types.package;
        description = "Which ArangoDB derivation to use";
      };

      dataDir = mkOption {
        type = types.path;
        example = "/var/db/arangodb";
        default = "/var/db/arangodb";
        description = "ArangoDB data dir";
      };

      arangodConf = mkOption {
        type = types.attrs;
        default = {
          server.endpoint               = "tcp://127.0.0.1:8529";
          server.storage-engine         = "auto";
          server.uid                    = "arangodb";
          database.directory            = cfg.dataDir;
          javascript.startup-directory  = "${cfg.package}/share/arangodb3/js";
          javascript.app-path           = cfg.dataDir;
          log.level                     = "info";
          log.file                      = "${cfg.dataDir}/arangodb.log";
        };
      };

      arangoshConf = mkOption {
        type = types.attrs;
        default = {
          console.pretty-print          = true;
          javascript.startup-directory  = "${cfg.package}/share/arangodb3/js";
          server.endpoint               = cfg.arangodConf.server.endpoint;
          server.password               = "";
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    users.extraUsers.arangodb = {
      name = "arangodb";
      group = "arangodb";
      uid = /*config.ids.uids.arangodb*/600;
      description = "ArangoDB server user";
    };

    users.extraGroups.arangodb.gid = /*config.ids.gids.arangodb*/600;
    boot.kernel.sysctl."vm.max_map_count" = lib.mkDefault 256000;

    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        name = "arangodb-cli-wrappers";
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildCommand = ''
          mkdir -p $out/bin
          makeWrapper ${cfg.package}/bin/arangosh $out/bin/arangosh \
            --argv0 ${cfg.package}/bin/arangosh \
            --add-flags "--configuration ${writeConfFile "arangosh.conf" cfg.arangoshConf}" \
            --set ICU_DATA "${cfg.package}/share/arangodb3"
        '';
      })
    ];

    systemd.services.arangodb = rec {
      description = "ArangoDB server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/arangod --configuration ${writeConfFile "arangod.conf" cfg.arangodConf}";
        User = "arangodb";
        Group = "arangodb";
        LimitNOFILE = 100000;
        PermissionsStartOnly = true;
        WorkingDirectory = "${cfg.package}";
      };

      preStart = ''
        install -d -m0700 -o ${escapeShellArg serviceConfig.User} -g ${escapeShellArg serviceConfig.Group} ${escapeShellArg cfg.dataDir}

        # just in case of uid/gid change
        chown -R ${escapeShellArg "${serviceConfig.User}:${serviceConfig.Group}"} ${escapeShellArg cfg.dataDir}
      '';
    };

  };

}
