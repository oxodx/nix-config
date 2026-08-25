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
  secrets = import ./secrets {inherit lib;};

  baseArgs = lib.optionalString silent "-s";
  methodArg = lib.optionalString (method != "GET") "-X ${method}";

  apiKeyHeaderArg =
    if apiKeyValue == null
    then ""
    else if secrets.isSecretRef apiKeyValue
    then ''--header "${apiKeyHeader}: $(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg (toString apiKeyValue._secret)} | ${pkgs.gnused}/bin/tr -d '\\n')"''
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
