{ config, pkgs, ... }:
{
  home.username = "dmeijboom";
  home.homeDirectory =
    if pkgs.stdenv.isLinux
    then "/home/dmeijboom"
    else "/Users/dmeijboom";

  home.packages = with pkgs; [
    # Generic
    zsh

    # Build tools
    devenv
    bazelisk
    buildifier
    buildozer
    skaffold

    # Misc tools
    duckdb
    ast-grep

    # Hacks
    rustup

    # Kubernetes
    kubie
    stern
    kubernetes-helm
    kubectl-cnpg
    mirrord

    # Cloud Tooling
    sops
    kubelogin
    (google-cloud-sdk.withExtraComponents( with google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]))
    # Build fails
    # (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
  ];
  home.shellAliases = {
    s = "lazygit";
    bazel = "bazelisk";
  };
  home.stateVersion = "23.11";

  imports = [
    ./config/shell.nix
    ./config/git.nix
    ./config/editor.nix
  ];
}
