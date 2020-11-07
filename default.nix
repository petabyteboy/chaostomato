{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, src ? pkgs.lib.cleanSource ./. }:

let
  naersk = pkgs.callPackage sources.naersk {};
in
  naersk.buildPackage {
    inherit src;
    nativeBuildInputs = with pkgs; [ pkgconfig ];
    buildInputs = with pkgs; [ openssl ];
  }
