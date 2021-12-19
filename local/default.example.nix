{ ... }:

# Copy this file as 'default.nix'

{
  imports = [
    # Kilin (my laptop)
    # ./desktops/machines/kilin.nix
    #
    # Arkilin (my desktop)
    # ./desktops/machines/arkilin.nix
    #
    # Sydkilin (my server)
    # ./servers/machines/sydkilin.nix 
    
    # Web server
    # ./web.nix
    #
    # Mail server
    # ./mail.nix
  ];

  # If using a web server, fill up web.nix, add it to the imports and uncomment this part
  # services.nginx.enable = true;
  # security.acme = {
  #   acceptTerms = true;
  #   email = "YOUR EMAIL";
  # };

  # If you want to enable mail server fill up ./mail.nix and add it to the imports

  # You choose (see NixOS doc)
  system.stateVersion = "19.03";
}
