with (import <nixpkgs> {});

# { stdenv, pkgs, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "epilink";
  version = "0.6.1";

  src = fetchFromGitHub {
    repo = "EpiLink";
    owner = "EpiLink";
    rev = "v${version}";
    sha256 = "0laf12a5skwgnxz589kibvc3hyasjq4gdx8m5bkv86dv9qs6kwgi";
  };

  nativeBuildInputs = with pkgs; [ gradle unzip ];
  buildInputs = with pkgs; [ jdk14_headless ];

  buildPhase = ''
    gradle epilink-backend:distZip
  '';

  installPhase = ''
    unzip bot/distributions/epilink-backend-${version}.zip -d $out
  '';
}
