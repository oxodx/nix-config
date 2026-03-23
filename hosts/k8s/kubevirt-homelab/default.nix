{
  lib,
  pkgs,
  mylib,
  myvars,
  disko,
  ...
}:
let
  hostName = "kubevirt-homelab";

  coreModule = mylib.genKubeVirtHostModule {
    inherit lib pkgs hostName;
    networking = myvars.networking;
  };
  k3sModule = mylib.genK3sServerModule {
    inherit pkgs;
    kubeconfigFile = "/home/${myvars.username}/.kube/config";
    tokenFile = "/persistent/kubevirt-k3s-token";
    # the first node in the cluster should be the one to initialize the cluster
    clusterInit = true;
    kubeletExtraArgs = [
      "--cpu-manager-policy=static"
      # https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/
      # we have to reserve some resources for for system daemons running as pods or system services
      # when cpu-manager's static policy is enabled
      # the memory we reserved here is also for the kernel, since kernel's memory is not accounted in pods
      "--system-reserved=cpu=1,memory=2Gi,ephemeral-storage=2Gi"
    ];
    nodeLabels = [
      "node-purpose=kubevirt"
    ];
    # kubevirt works well with k3s's flannel,
    # but has issues with cilium(failed to configure vmi network: setup failed, err: pod link (pod6b4853bd4f2) is missing).
    # so we should not disable flannel here.
    disableFlannel = false;
  };
in
{
  imports = (mylib.scanPaths ./.) ++ [
    disko.nixosModules.default
    ../disko-config/kubevirt-disko-fs.nix
    ./hardware-configuration.nix
    ./preservation.nix
    coreModule
    k3sModule
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    # disable transparent hugepage(allocate hugepages dynamically)
    "transparent_hugepage=never"

    # https://kubevirt.io/user-guide/compute/hugepages/
    #
    # pre-allocate hugepages manually(for kubevirt guest vms)
    # NOTE: the hugepages allocated here can not be used for other purposes!
    # so we should left some memory for the host OS and other vms that don't use hugepages
    "hugepagesz=1G"
    "hugepages=6"
  ];
}
