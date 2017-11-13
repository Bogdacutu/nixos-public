{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.nd-proxy;
in {
  options = {
    services.nd-proxy = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable nd-proxy.";
      };
      verbose = mkOption {
        type = types.bool;
        default = false;
      };
      interfaces = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = {};
        description = "NS, NA, RS, RA, RD or *";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nd-proxy = let
      verboseParam = if cfg.verbose then "-d" else "";
      ifaceParams = concatStringsSep " " (
        mapAttrsToList (iface: selection:
          "-i ${iface}${if any (x: x == "*") selection then "" else ":" + concatStringsSep "," selection}"
        ) cfg.interfaces
      );
    in {
      description = "ND Proxy";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nd-proxy}/bin/nd-proxy ${verboseParam} ${ifaceParams}";
        Type = "simple";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
