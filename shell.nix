{ pkgs ? import <nixpkgs> {}, ghc ? pkgs.haskell.compiler.ghc802 }:

with pkgs;

let
  openjdk = openjdk8;
  jvmlibdir =
    if stdenv.isLinux
    then "${openjdk}/lib/openjdk/jre/lib/amd64/server"
    else "${openjdk}/jre/lib/server";
in
haskell.lib.buildStackProject {
  name = "functionless";
  buildInputs = [ autoconf automake git gradle openjdk which zlib ];
  inherit ghc;
  extraArgs = ["--extra-lib-dirs=${jvmlibdir}"];
  LANG = "en_US.utf8";
}
