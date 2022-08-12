{
  description = "My awesomeWM configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    polar-nur.url = "github:polarmutex/nur";
    bling = { url = "github:BlingCorp/bling"; flake = false; };

  };
  outputs = { self, ... }@inputs:
    with inputs;
    {
      #home-managerModule = { config, lib, pkgs, ... }:
      #  import ./home-manager.nix {
      #    inherit config lib pkgs inputs;
      #  };
    } //
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ]
      (system:
        let

          #
          # OLD
          #
          pkgs = import nixpkgs {
            inherit system;
            allowBroken = false;
            allowUnfree = false;
            overlays = [
              polar-nur.overlays.default
            ];
          };

          awesome-test = pkgs.writeShellScriptBin "awesome-test"
            ''
              #!/usr/bin/env bash
              set -eu -o pipefail
              export AWESOME_THEME=$out/theme.lua
              Xephyr :5 -screen 1980x1200 & sleep 1 ; DISPLAY=:5 ${pkgs.awesome-git}/bin/awesome -c ${self.packages."${system}".awesome-config-polar}/rc.lua --search $out
            '';

        in
        rec {
          packages = flake-utils.lib.flattenTree rec {

            awesome-config-polar = pkgs.stdenv.mkDerivation rec {
              pname = "awesome-config-polar";
              version = "dev";

              src = ./dotfiles;

              dontBuild = true;

              nativeBuildInputs =
                [ pkgs.luaPackages.lgi pkgs.luaPackages.luafilesystem ];

              installPhase = ''
                cp -r . $out
                mkdir $out/modules/bling
                cp -r ${inputs.bling}/* $out/modules/bling/.
              '';

              meta = with pkgs.lib; {
                homepage = "https://github.com/polarmutex/awesome-flake";
                description = "Polarmutex's awesomeWM configuration";
                license = licenses.mit;
                maintainers = [ maintainers.polarmutex ];
              };
            };
          };

          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              awesome-test
            ];
          };

        });
}
