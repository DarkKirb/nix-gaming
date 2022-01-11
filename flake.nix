{
  description = "Gaming on Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  nixConfig = {
    substituters = [ "https://cache.nixos.org" "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  outputs = { self, nixpkgs, ... }@inputs:
    # only x86 linux is supported by wine
    let
      inherit (nixpkgs) lib;

      supportedSystems = [
        "i686-linux"
        "x86_64-linux"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);

      inherit self inputs;

      apps = forAllSystems (system: {
        osu-lazer = {
          program = packages.${system}.osu-lazer-bin.outPath + "/bin/osu-lazer";
          type = "app";
        };
      });

      #lib.mkPatches = import ./lib { inherit inputs; };

      packages = forAllSystems (system:
        /* lib.filterAttrs (n: v: v.meta.platforms == system) */ (import ./pkgs {
        inherit inputs;
        pkgs = import nixpkgs { inherit system; };
      }));
    in
    {
      inherit apps packages;

      nixosModules.pipewireLowLatency = import ./modules/pipewireLowLatency.nix;
      nixosModule = self.nixosModules.pipewireLowLatency;
    };
}
