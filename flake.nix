{
  description = "My awesomeWM configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    polar-nur.url = "github:polarmutex/nur";
    bling = {
      url = "github:BlingCorp/bling";
      flake = false;
    };
  };
  outputs = {self, ...} @ inputs:
    with inputs;
      {
        overlays.default = final: prev: let
          pkgs = import nixpkgs {
            system = prev.system;
            allowBroken = false;
            allowUnfree = false;
            overlays = [
              polar-nur.overlays.default
            ];
          };
        in rec {
          awesome-config-polar = pkgs.stdenv.mkDerivation rec {
            pname = "awesome-config-polar";
            version = "dev";

            src = ./dotfiles;

            dontBuild = true;

            nativeBuildInputs = [];

            installPhase = ''
              cp -r . $out
              mkdir $out/modules/bling
              cp -r ${inputs.bling}/* $out/modules/bling/.
            '';

            meta = with pkgs.lib; {
              homepage = "https://github.com/polarmutex/awesome-flake";
              description = "Polarmutex's awesomeWM configuration";
              license = licenses.mit;
              maintainers = [maintainers.polarmutex];
            };
          };
        };
      }
      // flake-utils.lib.eachSystem [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (system: let
        pkgs = import nixpkgs {
          overlays = [
            polar-nur.overlays.default
            self.overlays.default
          ];
          inherit system;
        };

        awesome-test =
          pkgs.writeShellScriptBin "awesome-test"
          ''
            #!/usr/bin/env bash
            set -eu -o pipefail
            export AWESOME_THEME=$out/theme.lua
            Xephyr :5 -screen 2560x1400 & sleep 1 ; DISPLAY=:5 ${pkgs.awesome-git}/bin/awesome -c ./dotfiles/rc.lua --search $out
          '';
      in rec {
        packages = with pkgs; {
          inherit awesome-config-polar;
          default = awesome-config-polar;
        };

        checks = {};

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            awesome-test
          ];
        };
      });
}
