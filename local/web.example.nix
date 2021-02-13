{ vhost, folder, proxy, folderWith, proxyWith, ... }:

# Copy this file to web.nix

{
  # "sub1.mydomain.com" = folder "/var/www";
  # "sub2.mydomain.com" = proxy http://localhost:1234;
  # "sub3.mydomain.com" = folderWith "/var/www2" "add_header Hello World;";
  # "sub4.mydomain.com" = proxyWith http://localhost:1235 "add_header Goodbye World;";
}
