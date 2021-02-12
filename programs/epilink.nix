{ stdenv, pkgs, fetchurl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "epilink";
  version = "0.6.1+deps_hotfix";

  src = fetchurl {
    url = "https://github.com/EpiLink/EpiLink/releases/download/v${version}/epilink-backend-${version}.zip";
    sha256 = "0q339g08nxqh2dyqf52hnm6sbnrb8cgb34p0fa41c9p3g2qgv0xd";
  };

  nativeBuildInputs = with pkgs; [ unzip makeWrapper ];
  buildInputs = with pkgs; [ jdk14_headless ];

  installPhase = ''
    cp -r ./ $out
    wrapProgram $out/bin/epilink-backend --set JAVA_HOME ${pkgs.jdk14_headless}
  '';
}
