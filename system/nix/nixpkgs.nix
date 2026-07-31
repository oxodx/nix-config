{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    overlays = [
      inputs.zed-extensions.overlays.default
    ];
  };
}
