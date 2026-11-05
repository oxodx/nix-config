# Installs this Neovim config for the current user on Windows.
# An existing config in %LOCALAPPDATA%\nvim is moved aside, not deleted.
$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = Join-Path $env:LOCALAPPDATA "nvim"

if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
  Write-Host "Neovim is not installed. Install Neovim 0.11 or newer first:"
  Write-Host "  winget install Neovim.Neovim"
  exit 1
}

foreach ($tool in "git", "rg", "fd", "make") {
  if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
    Write-Warning "Missing (recommended): $tool"
  }
}

if (Test-Path $dest) {
  $backup = "$dest.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
  Move-Item $dest $backup
  Write-Host "Moved your existing config to $backup"
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Recurse -Force -Path (Join-Path $here "init.lua"), (Join-Path $here "lua"), (Join-Path $here "custom-snippets") -Destination $dest

Write-Host "Installed to $dest"
Write-Host "Open nvim: lazy.nvim installs the plugins on first start. Then run :Mason to check the servers."
