{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    config.android_sdk.accept_license = true;
    overlays = [
      inputs.zed-extensions.overlays.default
    ];
  };
}
