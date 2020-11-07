{ sources ? import ./nix/sources.nix
, src ? null }:

let
  overlay = self: super: {
    naersk = self.callPackage sources.naersk (self.lib.optionalAttrs self.stdenv.targetPlatform.isStatic {
      stdenv = self.buildPackages.stdenv;
    });
    chaostomato = self.naersk.buildPackage ({
      src = if src != null then src else self.lib.cleanSource ./.;
      nativeBuildInputs = with self.buildPackages; [ pkgconfig ];
      buildInputs = with self; [ libressl ];
      CARGO_BUILD_TARGET = self.stdenv.targetPlatform.config;
    } // self.lib.optionalAttrs self.stdenv.targetPlatform.isStatic {
      "CARGO_TARGET_${self.lib.toUpper self.stdenv.cc.suffixSalt}_LINKER" = "${self.buildPackages.llvmPackages_10.lld}/bin/lld";
    });
  };
in
  import sources.nixpkgs {
    overlays = [ overlay ];
  }
