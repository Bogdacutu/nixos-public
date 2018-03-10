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

    patches = [
      ./0001-Remove-Makefile-references-to-kr-pkcs11.so.patch
    ];

    buildInputs = with pkgs; [
      go makeWrapper
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
      wrapProgram $out/bin/kr --set KR_SKIP_SSH_CONFIG 1
    '';
  };
in {
  options = {
    services.krypton.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Krypton";
    };
  };

  config = {
    nixpkgs.config.packageOverrides = pkgs: { kr = kr; };
  } // mkIf cfg.enable {
    environment.systemPackages = [ kr ];

    programs.ssh.extraConfig = ''
      Match exec "sh -c 'pgrep krd || nohup krd &'"
        IdentityAgent %d/.kr/krd-agent.sock
        ProxyCommand krssh %h %p
    '';
  };
}
