{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Kubernetes
    kubie
    stern
    kubernetes-helm
    mirrord
    skaffold

    # Cloud Tooling
    kubelogin
    (google-cloud-sdk.withExtraComponents( with google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]))
    (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
  ];
  home.shellAliases = {
    s = "lazygit";
  };
  home.stateVersion = "23.11";

  imports = [
    ./config/shell.nix
    ./config/git.nix
    ./config/editor.nix
  ];
}
