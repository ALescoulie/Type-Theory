{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}         
      );
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.haskellPackages.haskell-language-server
          pkgs.haskellPackages.hindent
          pkgs.haskell.compiler.ghc98
          pkgs.cabal-install
          pkgs.texliveSmall
        ];
      };
    });
  };
}
