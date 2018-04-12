{ pkgs ? import <nixpkgs> { system = "armv7l-linux"; }, ... } @ args: {
  kernel = import ./kernel.nix pkgs // args;
  kernel-1000hz = import ./kernel-1000hz.nix pkgs // args;
}
