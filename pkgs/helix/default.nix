{
  # The base helix package built from our fork's flake (github:dmeijboom/helix).
  # Use this attr to layer additional Nix-level customization on top of the
  # fork (extra grammars, runtime files, wrappers, env vars, ...).
  #
  # Source-level changes belong in the fork itself.
  helix-pkg,
}:
helix-pkg.overrideAttrs (old: {
  # Placeholder for future overrides (patches, extra runtime, postFixup, ...).
  # Keep this derivation in place even when empty so all consumers can rely
  # on `pkgs.helix` resolving to our customized build.
})
