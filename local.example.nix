{ ... }: {
  # Kilin (my laptop): imports = [ ./desktop/kilin.nix ];
  # Arkilin (my desktop): imports = [ ./desktop/arkilin.nix ];
  # Sydkilin (my server): imports = [ ./servers/sydkilin.nix ];

  # You choose (see NixOS doc)
  system.stateVersion = "19.03";
}
