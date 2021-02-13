{ config, ... }:

{
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    sslCiphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DES-CBC3-SHA";

    commonHttpConfig = ''
      ssl_session_timeout 1d;
      ssl_session_cache shared:MozSSL:10m;
      ssl_session_tickets off;
      ssl_prefer_server_ciphers off;

      ssl_stapling on;
      ssl_stapling_verify on;

      ssl_ecdh_curve secp384r1;

      add_header Expect-CT "max-age=0";
    '';

    virtualHosts = if config.services.nginx.enable then import ../local/web.nix rec {
      vhost = config: extra: ({
          http2 = true;
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
              add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
              charset UTF-8;

              ${extra}
          '';
      } // config);

      folderWith = path: extra: vhost { root = path; } extra;
      proxyWith = address: extra: vhost { locations."/" = { proxyPass = address; extraConfig = extra; }; } "";
      folder = path: folder path "";
      proxy = address: proxy address "";
    } else {};
  };
}
