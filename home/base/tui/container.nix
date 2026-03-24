{ pkgs, ... }:
{
  home.packages = with pkgs; [
    podman-compose
    dive
    lazydocker
    skopeo
    go-containerregistry

    kubectl
    kubectx
    kubie
    kubectl-view-secret
    kubectl-tree
    kubectl-node-shell
    kubepug
    kubectl-cnpg

    kubebuilder
    istioctl
    clusterctl
    kubevirt
    kubernetes-helm

    ko
  ];

  programs.k9s.enable = true;
  catppuccin.k9s.transparent = true;

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
}
