{
  allow = [
    "Read"
    "Bash(git diff:*)"
    "Edit"
    "Write"
    "mcp__serena__*"
    "mcp__octocode__*"
  ];
  defaultMode = "acceptEdits";
  deny = [
    "WebFetch"
    "Read(./.env)"
    "Read(./secrets/**)"
  ];
}
