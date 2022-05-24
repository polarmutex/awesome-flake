{
  description = "My awesomeWM configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    polar-nur.url = "github:polarmutex/nur";

  };
  outputs = { self, ... }@inputs:
    with inputs;
    let
      test = "rstin";
    in
    {
      home-managerModule = { config, lib, pkgs, ... }:
        import ./home-manager.nix {
          inherit config lib pkgs;
        };
    } //
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            allowBroken = false;
            allowUnfree = false;
            overlays = [
              polar-nur.overlay
            ];
          };
        in
        rec {
          packages = flake-utils.lib.flattenTree rec {

            awesome-configuration = pkgs.stdenv.mkDerivation rec {
              pname = "awesome-configration";
              version = "1.0";

              src = ./config/awesome;

              dontBuild = true;

              nativeBuildInputs =
                [ pkgs.luaPackages.lgi pkgs.luaPackages.luafilesystem ];

              installPhase = ''
                cp -r . $out
                cat >$out/run-test <<EOL
                #!/usr/bin/env bash
                set -eu -o pipefail
                export AWESOME_THEME=$out/theme.lua
                unset XDG_SEAT
                Xephyr :5 -screen 1900x1068 & sleep 1 ; DISPLAY=:5 ${pkgs.awesome-git}/bin/awesome -c $out/rc.lua --search $out
                EOL
                chmod +x $out/run-test
              '';

              meta = with pkgs.lib; {
                homepage = "https://github.com/pinpox/dotfiles-awesome";
                description = "Pinpox's awesomeWM configuration";
                license = licenses.mit;
                maintainers = [ maintainers.pinpox ];
              };
            };

          };

          apps = {
            test-config = flake-utils.lib.mkApp {
              drv = packages.awesome-configuration;
              exePath = "/run-test";
            };
          };

          defaultApp = apps.test-config;

        });
}

