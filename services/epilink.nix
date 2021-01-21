{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.epilink;
  yamlFormat = pkgs.formats.yaml { };

  externalFile = types.attrsOf (types.submodule {
    options = {
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "File URL";
      };

      file = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "File path on the filesystem";
      };

      contentType = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "File content type (MIME type)";
      };
    };
  });

  footer = types.attrsOf (types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "Displayed footer label";
      };

      url = mkOption {
        type = types.str;
        default = "";
        description = "Footer link target";
      };
    };
  });

  contact = types.attrsOf (types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        description = "The contact full name";
      };

      email = mkOption {
        type = types.str;
        default = "";
        description = "The contact e-mail address";
      };
    };
  });

  configFile = pkgs.writeText "epilink.yml" (replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg));
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

      name = mkOption {
        type = types.str;
        default = config.networking.hostname;
        description = "Instance name";
      };

      port = mkOption {
        type = types.port;
        default = 9090;
        description = "Backend HTTP server port";
      };

      proxyType = mkOption {
        type = types.enum [ "None" "Forwarded" "XForwarded" ];
        default = "None";
        description = ''
          Either None, Forwarded or XForwarded depending on how you use your reverse proxy to transmit the remote host's.

          !!SWITCH TO THE CORRECT VALUE! FAILURE TO DO SO COULD LEAD TO SECURITY FLAWS!!
          !!Make sure your reverse proxy overrides values the client sends. See here for more info: !!
          --> --> https://docs.zoroark.guru/#/ktor-rate-limit/usage?id=reverse-proxies-and-ip-address-spoofing <-- <--
          - None: No reverse proxy used, use the host's information directly
          - XForwarded: Use the X-Forwarded-* headers to get information about the remote host
          - Forwarded: Use the Forwarded standard header to get information about the remote host
        '';
      };

      frontendUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Front-end URL, or null if the URL is unknown or the front-end is bootstraped";
      };

      logo = mkOption {
        type = types.nullOr externalFile;
        default = null;
        description = "Custom instance logo displayed on the front-end, or the default EpiLink logo if null";
      };

      background = mkOption {
        type = types.nullOr externalFile;
        default = null;
        description = "Custom front-end background image, or a simple grey background if null";
      };

      footers = mkOption {
        type = types.listOf footer;
        default = [];
        description = "A list of custom footers shown on the front-end";
      };

      enableAdminEndpoints = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable /api/v1/admin endpoints";
      };

      unlinkCooldown = mkOption {
        type = types.int;
        default = 0;
        description = "Cooldown between an identity-sensitive event and users being able to remove their identity (in seconds)";
      };

      rateLimitingProfile = mkOption {
        type = types.enum [ "Disabled" "Lenient" "Standard" "Harsh" ];
        default = "Harsh";
        description = "Rate limiting profile, see maintener guide";
      };

      contacts = mkOption {
        type = types.listOf contact;
        default = [];
        description = "List of people users may contact about the instance. Displayed on the front-end";
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
