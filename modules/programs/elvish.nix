{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.elvish;

  elvenSessionVariables = lib.concatMapAttrsStringSep "\n" (
    name: value: "set-env ${name} '${toString value}'"
  ) config.home.sessionVariables;
in
{
  options = {
    programs.elvish = {
      enable = lib.mkEnableOption "Elvish, friendly and expressive command shell";

      package = lib.mkPackageOption pkgs "elvish" { };

      extraRC = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell script code called during elvish shell initialisation.
        '';
      };

      # TODO: option to configure library
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."elvish/rc.elv".text = /* elvish */ ''
      ${elvenSessionVariables}
      ${cfg.extraRC}
    '';
  };
}
