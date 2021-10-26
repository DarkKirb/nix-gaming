{ inputs }:

let
  inherit (inputs.nixpkgs.lib) callPackage hasSuffix filesystem;
in
rec {
  legendaryBuilder = { games ? [ ] }:
    map (e: callPackage ./legendary e) games;
  
  mkPatches = dir: map (e: builtins.toPath e)
    (builtins.filter
      (e: hasSuffix ".patch" e)
      (filesystem.listFilesRecursive dir));
}
