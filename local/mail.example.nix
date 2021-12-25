import ../servers/mail.nix {
  mainDomain = "example.com";
  domains = [ "example.com" "example2.com" ];

  accounts."test@example.com" = {
    # mkpasswd -m sha-512 "super secret password"
    hashedPassword = "SHA215HASH";

    aliases = [
      "postmaster@example.com"
      "postmaster@example2.com"
    ];

    # Make this user the catchAll address for domains example.com and
    # example2.com
    catchAll = [
      "example.com"
      "example2.com"
    ];
  };
}
