{ config
, pkgs
, lib
, ...
}:
with lib;
let
  dot = path: "${config.home.homeDirectory}/repos/personal/awesome-flake/${path}";

  link = path:
    let
      fullpath = dot path;
    in
    config.lib.file.mkOutOfStoreSymlink fullpath;

  link-one = from: to: path:
    let
      paths = builtins.attrNames { "${path}" = "directory"; };
      mkPath = path:
        let
          orig = "${from}/${path}";
        in
        {
          name = "${to}/${path}";
          value = {
            source = link orig;
          };
        };
    in
    builtins.listToAttrs (
      map mkPath paths
    );

  cfg = config.polar.programs.awesome;
in
{

  options = {

    polar.programs.awesome = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable awesome";
      };
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      awesome-git
    ];

    # old way
    xdg.configFile = link-one "config" "." "awesome";

  };

}
