{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
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
    (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
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
