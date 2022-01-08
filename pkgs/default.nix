{ inputs, pkgs }:

let
  wineBuilder = wine: build: extra: (import ./wine ({
    inherit inputs build;
    inherit (pkgs) lib pkgsCross pkgsi686Linux fetchFromGitHub callPackage stdenv_32bit;
    inherit pkgs;
    supportFlags = (import ./wine/supportFlags.nix).${build};
  } // extra)).${wine};

  inherit (pkgs) callPackage;
in
rec {
  osu-lazer-bin = callPackage ./osu-lazer-bin { };

  osu-stable = callPackage ./osu-stable {
    wine = wine-osu;
    inherit winestreamproxy;
  };

  rocket-league = callPackage ./rocket-league { wine = wine-tkg; };

  technic-launcher = callPackage ./technic-launcher { };

  winestreamproxy = callPackage ./winestreamproxy { wine = wine-tkg; };

  wine-osu = wineBuilder "wine-osu" "base" { };

  wine-tkg = wineBuilder "wine-tkg" "base" { };

  wine-tkg-full = wineBuilder "wine-tkg" "full" { };
}
