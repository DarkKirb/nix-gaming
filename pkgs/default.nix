{ inputs, self }:

final: prev:
let
  wineBuilder = wine: build: extra: (import ./wine ({
    inherit inputs build;
    inherit (prev) lib pkgsCross pkgsi686Linux fetchFromGitHub fetchurl callPackage stdenv_32bit;
    pkgs = prev;
    supportFlags = (import ./wine/supportFlags.nix).${build};
  } // extra)).${wine};
in
{
  osu-lazer-bin = prev.callPackage ./osu-lazer-bin { };

  osu-stable = prev.callPackage ./osu-stable {
    wine = final.wine-osu;
    wine-discord-ipc-bridge = final.wine-discord-ipc-bridge.override { wine = final.wine-osu; };
  };

  #rocket-league = prev.callPackage ./rocket-league { wine = final.wine-tkg; };
  
  rocket-league = self.lib.legendaryBuilder {
    games = [
      {
        name = "Rocket League";
        pname = "rocket-league";
        tweaks = [ "dxvk" "win10" ];
        icon = builtins.fetchurl {
          url = "https://www.pngkey.com/png/full/16-160666_rocket-league-png.png";
          name = "rocket-league.png";
          sha256 = "09n90zvv8i8bk3b620b6qzhj37jsrhmxxf7wqlsgkifs4k2q8qpf";
        };
      }
    ];
  };

  technic-launcher = prev.callPackage ./technic-launcher { };

  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge { wine = final.wine-tkg; };

  wine-osu = wineBuilder "wine-osu" "base" { };

  wine-tkg = wineBuilder "wine-tkg" "base" { };

  wine-tkg-full = wineBuilder "wine-tkg" "full" { };

  winestreamproxy = prev.callPackage ./winestreamproxy { wine = final.wine-tkg; };
}
