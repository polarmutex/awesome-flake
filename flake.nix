{
  description = "My awesomeWM configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    awesome-src = { url = "github:awesomeWM/awesome"; flake = false; };
  };
  outputs = { self, ... }@inputs:
    with inputs;
    let
      test = "rstin";
      overlay = final: prev: {
        #awesome-config = self.packages.${prev.system}.awesome-config;
        awesome-git = self.packages.${prev.system}.awesome-git;
        #lain = self.packages.${prev.system}.lain;
      };
    in
    { } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          allowBroken = false;
          allowUnfree = false;
          overlays = [ overlay ];
        };
      in
      rec {
        packages = flake-utils.lib.flattenTree rec {

          awesome-git = (pkgs.awesome.overrideAttrs
            (oldAttrs: rec {
              src = awesome-src;
              version = "git";
            })).override {
            lua = pkgs.lua5_3;
            gtk3Support = true;
            gtk3 = pkgs.gtk3;
          };

          awesome-configuration = pkgs.stdenv.mkDerivation rec {
            pname = "awesome-configration";
            version = "1.0";

            src = ./config;

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
              Xephyr :5 -screen 1024x768 & sleep 1 ; DISPLAY=:5 ${pkgs.awesome-git}/bin/awesome -c $out/rc.lua --search $out
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

        defaultPackage = packages.awesome-configuration;
        defaultApp = apps.test-config;

      });
}

