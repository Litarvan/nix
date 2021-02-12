{ stdenv, pkgs, fetchurl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "shenron";
  version = "3.5.1";

  src = fetchurl {
    url = "https://github.com/Litarvan/Shenron/releases/download/v${version}/shenron-${version}.zip";
    sha256 = "0k22sgafj3x9i9a3jci1wwpl6kfqh1873bggq3jaf7x8rgz2krjp";
  };

  nativeBuildInputs = with pkgs; [ unzip makeWrapper ];
  buildInputs = with pkgs; [ jdk14_headless ];

  installPhase = ''
    cp -r ./ $out
    wrapProgram $out/bin/shenron --set JAVA_HOME ${pkgs.jdk14_headless}
  '';
}