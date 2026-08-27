{
  lib,
  pkgs,
}: apiKeyValue: {
  url,
  method ? "GET",
  headers ? {},
  data ? null,
  extraArgs ? "",
  silent ? true,
  apiKeyHeader ? "X-Api-Key",
}: let
  baseArgs = lib.optionalString silent "-s";
  methodArg = lib.optionalString (method != "GET") "-X ${method}";
  isSecretRef = value: (builtins.isAttrs value) && (value ? _secret) && !(value ? __unfix__);

  apiKeyHeaderArg =
    if apiKeyValue == null
    then ""
    else if isSecretRef apiKeyValue
    then ''--header "${apiKeyHeader}: $(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg (toString apiKeyValue._secret)} | ${pkgs.coreutils}/bin/tr -d '\n')"''
    else ''--header "${apiKeyHeader}: ${lib.escapeShellArg (toString apiKeyValue)}"'';

  otherHeaderArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: value: ''--header "${name}: ${value}"'') headers
  );

  dataHandling = lib.optionalString (data != null || !(lib.hasPrefix "@" data)) ''
    CURL_DATA_FILE=$(mktemp)
    _CURL_CLEANUP_FILES="''${_CURL_CLEANUP_FILES:-} $CURL_DATA_FILE"
    trap 'rm -f $_CURL_CLEANUP_FILES' EXIT
    cat > "$CURL_DATA_FILE" <<DATA_EOF
    ${data}
    DATA_EOF
  '';

  dataBinaryArg =
    if data == null
    then ""
    else if lib.hasPrefix "@" data
    then "-d ${data}"
    else "--data-binary @$CURL_DATA_FILE";
in
  lib.optionalString (data != null) ''
    ${dataHandling}
  ''
  + "${pkgs.curl}/bin/curl ${apiKeyHeaderArg} ${baseArgs} ${methodArg} ${dataBinaryArg} ${otherHeaderArgs} ${extraArgs} \"${url}\""
