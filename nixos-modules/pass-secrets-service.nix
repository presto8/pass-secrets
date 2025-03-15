{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:

with lib;

let
  cfg = config.services.pass-secrets;
in
{
  # Interface
  options = {
    services.pass-secrets = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run the pass-secrets service
        '';
      };
    };
  };

  # Implementation
  config = mkIf cfg.enable {
    # environment.systemPackages = [ pkgs.pass-secrets ];
    systemd.user.services.pass-secrets = {
      wantedBy = [ "default.target" ];
      path = [ pkgs.pass ];
      serviceConfig = {
        ExecStart = "${pkgs.pass-secrets}/bin/pass-secrets";
        Restart = "always";
      };
    };
  };
}
