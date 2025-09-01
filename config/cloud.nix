{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.custom.cloud.enable {
    home.packages = with pkgs; [
      # Kubernetes
      kubie
      stern
      kubernetes-helm
      kubectl-cnpg
      mirrord

      # Cloud Tooling
      sops
      skaffold
      kubelogin
      (google-cloud-sdk.withExtraComponents (
        with google-cloud-sdk.components;
        [
          gke-gcloud-auth-plugin
        ]
      ))
      # Build fails
      # (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
    ];
  };
}
