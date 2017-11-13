{ config, pkgs, lib, ... }:
with lib;
let
  boolString = b: if b then "true" else "false";

  cfg = config.services.ndppd;

  proxyRuleCfg = { config, ... }: {
    options = {
      iface = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          null
            'ndppd' will immediately answer any Neighbor Solicitation Messages
            (if they match the IP rule).

          <interface>
            'ndppd' will forward the Neighbor Solicitation Message through the
            specified interface - and only respond if a matching Neighbor
            Advertisement Message is received.

          auto
            Same as above, but instead of manually specifying the outgoing
            interface, 'ndppd' will check for a matching route in /proc/net/ipv6_route.
        '';
      };
      autoVia = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Any addresses updated using NDP advertisments will use a gateway to
          route traffic on this particular interface (only works wiith the iface
          rule type).
        '';
      };
    };
  };

  proxyCfg = { config, ... }: {
    options = {
      router = mkOption {
        type = types.bool;
        default = true;
        description = ''
          This option turns on or off the router flag for Neighbor Advertisement messages.
        '';
      };
      timeout = mkOption {
        type = types.int;
        default = 500;
        description = ''
          Controls how long to wait for a Neighbor Advertisment message before
          invalidating the entry, in milliseconds.
        '';
      };
      autoWire = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Controls whether ndppd will automatically create host entries
          in the routing tables when it receives Neighbor Advertisements on a
          listening interface.
          Note: Autowire will ignore all rules with 'auto' or 'static' given it
          is expected that the routes are already defined for these paths
        '';
      };
      keepAlive = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Controls whether ndppd will automatically attempt to keep routing
          sessions alive by actively sending out NDP Solicitations before the the
          session is expired.
        '';
      };
      retries = mkOption {
        type = types.int;
        default = 3;
        description = ''
          Number of times a NDP Solicitation will be sent out before the daemon
          considers a route unreachable.
        '';
      };
      promiscuous = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Controls whether ndppd will put the proxy listening interface into promiscuous
          mode and hence will react to inbound and outbound NDP commands. This is
          required for machines behind the gateway to talk to each other in more
          complex topology scenarios.
        '';
      };
      ttl = mkOption {
        type = types.int;
        default = 30000;
        description = ''
          Controls how long a valid or invalid entry remains in the cache, in
          milliseconds.
        '';
      };
      prefixes = mkOption {
        type = types.attrsOf (types.submodule proxyRuleCfg);
        default = [];
      };
    };
  };

  configFile = pkgs.writeText "ndppd.conf" ''
    route-ttl ${toString cfg.routeTTL}
    address-ttl ${toString cfg.addressTTL}
    ${concatStringsSep "\n" (mapAttrsToList (iface: proxy: ''
      proxy ${iface} {
        router ${boolString proxy.router}
        timeout ${toString proxy.timeout}
        autowire ${boolString proxy.autoWire}
        keepalive ${boolString proxy.keepAlive}
        retries ${toString proxy.retries}
        promiscuous ${boolString proxy.promiscuous}
        ttl ${toString proxy.ttl}
        ${concatStringsSep "\n" (mapAttrsToList (prefix: conf: ''
          prefix ${prefix} {
            ${if conf.iface == null then "static" else
              if conf.iface == "auto" then "auto" else "iface ${conf.iface}"}
            autovia ${boolString conf.autoVia}
          }
        '') proxy.prefixes)}
      }
    '') cfg.proxies)}
  '';
in {
  options = {
    services.ndppd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ndppd.";
      };
      verbosity = mkOption {
        type = types.enum [ 0 1 2 3 ];
        default = 0;
      };
      routeTTL = mkOption {
        type = types.int;
        default = 30000;
        description = ''
          This tells 'ndppd' how often to reload the route file /proc/net/ipv6_route.
        '';
      };
      addressTTL = mkOption {
        type = types.int;
        default = 30000;
        description = ''
          This tells 'ndppd' how often to reload the IP address file /proc/net/if_inet6
        '';
      };
      proxies = mkOption {
        type = types.attrsOf (types.submodule proxyCfg);
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ndppd = let
      pidFile = "/var/run/ndppd.pid";
      verbosityParam = if cfg.verbosity > 0 then "-" + (fixedWidthString cfg.verbosity "v" "") else "";
    in {
      description = "NDP Proxy Daemon";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ndppd}/bin/ndppd -d -p ${pidFile} -c ${configFile} ${verbosityParam}";
        Type = "forking";
        PIDFile = pidFile;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
