{ pkgs, ... }:
let
  base = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromGitHub {
      owner = "DanielAdolfsson";
      repo = "ndppd";
      rev = "eb81b8f2d6d4d33545570402b049a73880b9ad01";
      sha256 = "1b0xda2cr4yq2pj8zch9gvfxqvz1n5rjl4nyqn70jyrincvsi8qn";
    };

    buildInputs = [ pkgs.pkgconfig pkgs.glib ];

    postPatch = ''
      substituteInPlace Makefile \
        --replace /bin/gzip ${pkgs.gzip}/bin/gzip \
        --replace /usr/local $out
    '';

    enableParallelBuilding = true;
  };
in {
  config = {
    nixpkgs.config.packageOverrides = pkgs: rec {
      ndppd = base.overrideAttrs (_: {
        name = "ndppd";
      });

      nd-proxy = base.overrideAttrs (_: {
        name = "nd-proxy";

        buildFlags = [ "nd-proxy" ];
        installPhase = ''
          mkdir -p $out/bin
          cp nd-proxy $out/bin
        '';
      });
    };
  };
}
