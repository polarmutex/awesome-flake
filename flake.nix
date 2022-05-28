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
              polar-nur.overlays.default
            ];
          };

          inherit (builtins) filter;
          inherit (pkgs) lib mkShell writeShellScriptBin;

          extensions = [
            pkgs.awesome-battery-widget-git
            pkgs.bling-git
            pkgs.rubato-git
          ];

          # From https://github.com/rycee/home-manager/blob/master/modules/services/window-managers/awesome.nix
          makeSearchPath = lib.concatMapStrings (path:
            " --search ${getLuaPath path "share"}"
            + " --search ${getLuaPath path "lib"}"
          );
          getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.luaPackages.lua.luaversion}";

          awesome-test = pkgs.writeShellScriptBin "awesome-test" ''
            export GUEST_DISPLAY=:10
            unset XDG_SEAT
            ${pkgs.xorg.xorgserver}/bin/Xephyr -br -ac -noreset -screen 1280x1000 $GUEST_DISPLAY &
            export DISPLAY=$GUEST_DISPLAY
            X_PID=$!
            trap "kill $X_PID || true" EXIT
            sleep 1
            ${pkgs.awesome-git}/bin/awesome -c rc.lua --search config ${makeSearchPath (filter (x: lib.isDerivation x) extensions)}
          '';
        in
        rec {

          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              awesome-git
              awesome-test
            ];
          };

        });
}

