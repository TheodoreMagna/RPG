{
  description = "Epitech RPG project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);

    nativeDeps = pkgs: [
      pkgs.gnumake
      pkgs.pkg-config
    ];

    buildDeps = pkgs: [
      pkgs.sfml
      pkgs.csfml
    ];
  in {
    packages = eachSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.stdenv.mkDerivation {
          name = "rpg-ntml";
          src = ./.;

          nativeBuildInputs = nativeDeps pkgs;
          buildInputs = buildDeps pkgs;

          buildPhase = ''
            make -j$(nproc) all
          '';

          installPhase = ''
            make install DESTDIR=$out
          '';
        };
      }
    );

    devShells = eachSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          nativeBuildInputs = nativeDeps pkgs;
          buildInputs = buildDeps pkgs;

          shellHook = ''
            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.csfml}/include -I${pkgs.sfml}/include"
            echo "🛡️  RPG Development Environment Loaded"
          '';
        };
      }
    );
  };
}