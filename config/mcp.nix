{
  lib,
  config,
  pkgs,
  ...
}:
let
  # https://github.com/imdinu/apple-mail-mcp
  apple-mail-mcp = pkgs.writeShellScriptBin "apple-mail-mcp" ''
    exec ${pkgs.uv}/bin/uvx --prerelease=allow apple-mail-mcp@0.2.2 "$@"
  '';

  claudeConfig = "${config.home.homeDirectory}/Library/Application Support/Claude/claude_desktop_config.json";

  mcpFragment = builtins.toJSON {
    mcpServers.mail.command = "${apple-mail-mcp}/bin/apple-mail-mcp";
  };
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [
      pkgs.uv
      apple-mail-mcp
    ];

    # Merge our MCP entry into the existing Claude Desktop config rather
    # than overwriting it, so UI-managed settings are preserved.
    home.activation.mergeAppleMailMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$(dirname ${lib.escapeShellArg claudeConfig})"
      if [ ! -f ${lib.escapeShellArg claudeConfig} ]; then
        run echo '{}' > ${lib.escapeShellArg claudeConfig}
      fi
      tmp=$(${pkgs.coreutils}/bin/mktemp)
      run ${pkgs.jq}/bin/jq -S --argjson fragment ${lib.escapeShellArg mcpFragment} \
        '. * $fragment' ${lib.escapeShellArg claudeConfig} > "$tmp"
      run mv "$tmp" ${lib.escapeShellArg claudeConfig}
    '';
  };
}
