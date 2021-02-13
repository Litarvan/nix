{ ... }:

# Copy this file to default.nix

{
  # Kilin (my laptop): imports = [ ./desktops/machines/kilin.nix ];
  # Arkilin (my desktop): imports = [ ./desktops/machines/arkilin.nix ];
  # Sydkilin (my server): imports = [ ./servers/machines/sydkilin.nix ];


  # If using a web server
  # security.acme = {
  #   acceptTerms = true;
  #   email = "YOUR EMAIL";
  # };


  # You choose (see NixOS doc)
  system.stateVersion = "19.03";
}
