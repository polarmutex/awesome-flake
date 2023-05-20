{
  description = "My awesomeWM configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    awesome-git-src = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };
    bling = {
      url = "github:BlingCorp/bling";
      flake = false;
    };
  };
  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages = {
          default = pkgs.hello;
          awesome-git =
            (pkgs.awesome.overrideAttrs (_: let
              extraGIPackages = with pkgs; [networkmanager upower playerctl];
            in {
              version = "master";
              src = inputs.awesome-git-src;
              patches = [];

              postPatch = ''
                patchShebangs tests/examples/_postprocess.lua
                patchShebangs tests/examples/_postprocess_cleanup.lua
              '';

              GI_TYPELIB_PATH = let
                mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
                extraGITypeLibPaths = pkgs.lib.forEach extraGIPackages mkTypeLibPath;
              in
                pkgs.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [(mkTypeLibPath pkgs.pango.out)]);
            }))
            .override {
              gtk3Support = true;
            };

          awesome-config-polar = pkgs.stdenv.mkDerivation {
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

        devShells = {
          #default = shell {inherit self pkgs;};
          default = let
            awesome-test =
              pkgs.writeShellScriptBin "awesome-test"
              ''
                #!/usr/bin/env bash
                set -eu -o pipefail
                export AWESOME_THEME=$out/theme.lua
                Xephyr :5 -screen 2560x1400 & sleep 1 ; DISPLAY=:5 ${self'.packages.awesome-git}/bin/awesome -c ./dotfiles/rc.lua --search $out
              '';
          in
            pkgs.mkShell {
              name = "dev-shell";
              packages = with pkgs; [
                awesome-test
                statix
              ];
              #inherit (self.checks.${system}.pre-commit-check) shellHook;
            };
        };
      };
      flake = {
        overlays.default = _final: _prev: {
          awesome-git = self.packages.awesome-git;
        };
      };
    };
}
