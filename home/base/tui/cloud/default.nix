{ lib, pkgs, ... }: {
  home.file.".terraformrc".source = ./terraformrc;

  home.packages = with pkgs; [
    # aws
    awscli2
    ssm-session-manager-plugin # Amazon SSM Session Manager Plugin
    aws-iam-authenticator
    eksctl

    # aliyun
    aliyun-cli
    # digitalocean
    doctl
    # google cloud
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))

    # cloud tools that nix do not have cache for.
    terraform
    terraformer # generate terraform configs from existing cloud resources
    packer # machine image builder
  ];
}
