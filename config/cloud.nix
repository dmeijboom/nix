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
      (kubelogin.overrideAttrs (_: {
        doCheck = false;
      }))
      (google-cloud-sdk.withExtraComponents (
        with google-cloud-sdk.components;
        [
          gke-gcloud-auth-plugin
        ]
      ))
      (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
    ];
  };
}
