# Windows VM setup: CLI tools, fonts, Git Bash rc, and minimal-mode Neovim.
#
# Requires: winget, Developer Mode (for unelevated symlinks), repo cloned at %USERPROFILE%\.dotfiles
# Run:
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.dotfiles\scripts\windows-setup.ps1"

$ErrorActionPreference = "Stop"

$repo = Split-Path $PSScriptRoot -Parent
$expected = Join-Path $HOME ".dotfiles"
if ($repo -ne $expected) {
    Write-Warning "repo is at '$repo' but the bashrc and nvim stub expect '$expected'"
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found - install 'App Installer' from the Microsoft Store first"
}

function Ensure-Installed($id) {
    winget list -e --id $id --accept-source-agreements 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$id already installed"
    } else {
        winget install -e --id $id --accept-source-agreements --accept-package-agreements
    }
}

Ensure-Installed "Git.Git"
Ensure-Installed "Neovim.Neovim"
Ensure-Installed "JesseDuffield.lazygit"
Ensure-Installed "BurntSushi.ripgrep.MSVC"
Ensure-Installed "lsd-rs.lsd"

# cmd's mklink honors Developer Mode without elevation; New-Item in Windows PowerShell 5.1 doesn't
function Ensure-Symlink($link, $target) {
    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $target) {
            Write-Host "$link already linked"
            return
        }
        Remove-Item $link -Force
    }
    cmd /c mklink "$link" "$target" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "mklink failed for '$link' - is Developer Mode enabled?" }
    Write-Host "$link -> $target"
}

Ensure-Symlink (Join-Path $HOME ".bashrc") (Join-Path $repo "windows\bashrc")

# Git Bash (login shell) only reads ~/.bashrc if ~/.bash_profile sources it
$bashProfile = Join-Path $HOME ".bash_profile"
if (-not (Test-Path $bashProfile)) {
    Set-Content -Path $bashProfile -Value '[ -f ~/.bashrc ] && . ~/.bashrc'
    Write-Host "created $bashProfile"
}

$nvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
New-Item -ItemType Directory -Force -Path $nvimConfigDir | Out-Null
Ensure-Symlink (Join-Path $nvimConfigDir "init.lua") (Join-Path $repo "nvim\windows-init.lua")

# fonts: per-user install (no admin), registered under HKCU
$fontDir = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
$fontReg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
New-Item -ItemType Directory -Force -Path $fontDir | Out-Null
if (-not (Test-Path $fontReg)) { New-Item -Path $fontReg -Force | Out-Null }
Get-ChildItem (Join-Path $repo "fonts") | Where-Object { $_.Extension -in ".ttf", ".otf" } | ForEach-Object {
    $dest = Join-Path $fontDir $_.Name
    if (-not (Test-Path $dest)) {
        Copy-Item $_.FullName $dest
        $type = if ($_.Extension -eq ".otf") { "OpenType" } else { "TrueType" }
        New-ItemProperty -Path $fontReg -Name "$($_.BaseName) ($type)" -Value $dest -PropertyType String -Force | Out-Null
        Write-Host "installed font $($_.Name)"
    }
}

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if ($gitCmd) {
    $bash = Join-Path (Split-Path (Split-Path $gitCmd.Source)) "bin\bash.exe"
    Write-Host ""
    Write-Host "Done. Point your terminal profile at: `"$bash`" -i -l"
} else {
    Write-Host ""
    Write-Host "Done. Git was just installed - open a new terminal (fresh PATH), then rerun this script to locate bash.exe."
}
