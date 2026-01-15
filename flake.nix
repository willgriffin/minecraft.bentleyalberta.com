{
  description = "Minecraft GitOps Realm - Distroless OCI Images";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Java runtime - Eclipse Temurin JRE 21
        jre = pkgs.temurin-jre-bin-21;

        # Import component definitions
        velocityDef = import ./images/velocity { inherit pkgs jre; };
        fabricDef = import ./images/fabric { inherit pkgs jre; };

      in {
        packages = {
          velocity-image = velocityDef.image;
          fabric-image = fabricDef.image;

          # Utility for checking mod updates
          check-mod-updates = pkgs.writeShellScriptBin "check-mod-updates" ''
            echo "Checking for mod updates..."
            # TODO: Implement Modrinth/GitHub API checks
          '';

          default = self.packages.${system}.fabric-image;
        };

        # Development shell with useful tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            docker
            jre
            curl
            jq
          ];
        };
      }
    );
}
