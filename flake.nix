{
  description = "A flake to run Asty's silly discord bot";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    naersk,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      naerskLib = pkgs.callPackage naersk {};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          rustc
          clippy
          rustfmt
          rust-analyzer
          sqlx-cli
          sqlite
          openssl
        ];

        nativeBuildInputs = [pkgs.pkg-config];

        env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };

      packages.default = naerskLib.buildPackage {
        src = ./.;
        buildInputs = with pkgs; [
          sqlite
          openssl
        ];
        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
      };
    });
}
