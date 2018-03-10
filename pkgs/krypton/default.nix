{ config, lib, pkgs, ... }: with lib; let 
  cfg = config.services.krypton;

  kr = pkgs.stdenv.mkDerivation {
    name = "kr";
    src = pkgs.fetchFromGitHub {
      owner = "kryptco";
      repo = "kr";
      rev = "8fdb6c116a7295778b71fb560501583a9541dab9";
      sha256 = "0vjlpxdmmcli0fkfl3wm020m885rqjzr94ywb7d1g3j3pkzmxbx0";
    };

    buildInputs = with pkgs; [
      cargo go makeWrapper
    ];

    # impure
    postUnpack = ''
      export GOPATH=$(pwd)
      export GOCACHE=$GOPATH/.cache/go-build
      mkdir -p src/github.com/kryptco
      mv source src/github.com/kryptco/kr
      ln -s src/github.com/kryptco/kr source
    '';

    postPatch = ''
      substituteInPlace Makefile --replace sudo ""
    '';

    dontBuild = true;

    makeFlags = [ "PREFIX=$(out)" ];

    postInstall = ''
      wrapProgram $out/bin/kr --set PREFIX /etc/krypton-dist
    '';
  };
in {
  options = {
    services.krypton.users = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "root" ];
      description = "List of users to enable krd for.";
    };
  };

  config = {
    nixpkgs.config.packageOverrides = pkgs: { kr = kr; };
  } // mkIf (length cfg.users > 0) {
    environment.systemPackages = [ kr ];

    environment.etc.krypton-dist.source = kr;

    systemd.services = {
      "kr@" = {
        aliases = map (user: "kr@${user}.service") cfg.users;
        description = "Kryptonite daemon (%I)";
        environment.PREFIX = kr;
        serviceConfig = {
          ExecStart = "${kr}/bin/krd";
          Restart = "on-failure";
          User = "%I";
        };
        wantedBy = [ "default.target" ];
      };
    };
  };
}
