# Aggregator for all custom packages.
#
# Pattern:
#   - Packages we fully derive ourselves live in ./<name>/default.nix and
#     are called with `pkgs.callPackage`.
#   - Packages sourced from external flake inputs (helix, zjstatus, ...) are
#     wired in here so they get a single, predictable name in `pkgs`.
#
# To add a new app:
#   1. (optional) add the upstream flake to inputs in ../flake.nix
#   2. create ./<name>/default.nix taking whatever it needs as arguments
#   3. add an entry below
{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  helix = final.callPackage ../pkgs/helix {
    helix-pkg = inputs.helix.packages.${system}.default;
  };

  zjstatus = inputs.zjstatus.packages.${system}.default;

  # devenv 2.1.x — nixpkgs unstable currently lags at 2.0.6.
  devenv = inputs.devenv.packages.${system}.devenv;
}
