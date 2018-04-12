{ ... } @ args: import ./kernel.nix (args // rec {
  extraConfig = ''
    HZ_100 n
    HZ_1000 y
    HZ 1000
  '';
} // (args.argsOverride or {}))
