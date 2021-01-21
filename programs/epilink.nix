{ stdenv, pkgs, fetchurl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "epilink";
  version = "0.6.1+deps_hotfix";

  src = fetchurl {
    url = "https://github.com/EpiLink/EpiLink/releases/download/v${version}/epilink-backend-${version}.zip";
    sha256 = "04x578d4vz3wgj7k70q6p7xqnki18hp76jky3jb1sqsrm0mbayrz";
  };

  nativeBuildInputs = with pkgs; [ unzip makeWrapper ];
  buildInputs = with pkgs; [ jdk14_headless ];

  installPhase = ''
    cp -r ./ $out
    wrapProgram $out/bin/epilink-backend --set JAVA_HOME ${pkgs.jdk14_headless}
  '';
}
