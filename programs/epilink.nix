{ stdenv, pkgs, fetchurl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "epilink";
  version = "0.7.0-beta3";

  src = fetchurl {
    url = "https://github.com/EpiLink/EpiLink/releases/download/v${version}/epilink-backend-${version}.zip";
    sha256 = "0dvpmnzfcqbav7zsr4ralcf8nhnd3y9bf9cvjwyf0b5hglbpibji";
  };

  nativeBuildInputs = with pkgs; [ unzip makeWrapper ];

  installPhase = ''
    cp -r ./ $out
    wrapProgram $out/bin/epilink-backend --set JAVA_HOME ${pkgs.jdk17_headless}
  '';
}
