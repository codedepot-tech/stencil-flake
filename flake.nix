{
  description = "A very basic flake";

  nixConfig.bash-prompt = "stencil~~$ ";

  inputs = {
    stencil-src.url = "github:ionic-team/stencil";
    stencil-src.flake = false;
  };

  outputs = { self, nixpkgs, stencil-src }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      stencil = pkgs.mkYarnPackage {
        name = "stencil";
        src = stencil-src;
        packageJSON = ./package.json;
        yarnLock = ./yarn.lock;
        yarnNix = ./yarn.nix;
      };
    in rec 
      {
        packages.x86_64-linux.stencil = stencil;
        defaultPackage.x86_64-linux = stencil;
        devShell = pkgs.mkShell {
          buildInputs = [
            stencil
          ];
          shellHook = ''
            echo ""
            echo "Welcome to StencilJS"
            echo ""
          '';
        };
      };
}
