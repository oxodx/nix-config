{pkgs, ...}: {
  # register nix dotnet so prebuilt apphosts (e.g. zed's roslyn lsp) can find
  # the runtime via the "registered location" lookup instead of env vars
  # https://learn.microsoft.com/en-us/dotnet/core/dependency-loading/default-probing
  environment.etc."dotnet/install_location".text = "${pkgs.dotnet-sdk_10}/share/dotnet";
  environment.etc."dotnet/install_location_x64".text = "${pkgs.dotnet-sdk_10}/share/dotnet";
}
