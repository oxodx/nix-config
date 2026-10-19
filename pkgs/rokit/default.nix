{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  openssl,
}:
stdenv.mkDerivation rec {
  pname = "rokit";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/rojo-rbx/rokit/releases/download/v${version}/rokit-${version}-linux-x86_64.zip";
    hash = "sha256-lRp/PsPSpeAh/Rhn0y9p8BDuTCkn9kS3WVeK/FnGX8A=";
  };

  nativeBuildInputs = [unzip autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib openssl];
  sourceRoot = ".";
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 rokit "$out/bin/rokit"
    runHook postInstall
  '';

  meta = {
    description = "Toolchain manager for Roblox projects";
    homepage = "https://github.com/rojo-rbx/rokit";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    mainProgram = "rokit";
  };
}
