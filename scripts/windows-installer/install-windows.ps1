# ast-grep Windows Installer
# Version: 0.40.0 (Improved Edition)
# This script installs ast-grep on Windows systems

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\Programs\ast-grep",
    [switch]$AddToPath,
    [switch]$SystemWide,
    [switch]$Help,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

# Display help
if ($Help) {
    Write-Host "ast-grep Windows Installer"
    Write-Host "Version: 0.40.0 (Improved Edition)"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\install-windows.ps1                    Install to user directory"
    Write-Host "  .\install-windows.ps1 -SystemWide        Install system-wide (requires admin)"
    Write-Host "  .\install-windows.ps1 -AddToPath         Add to PATH automatically"
    Write-Host "  .\install-windows.ps1 -InstallPath PATH  Custom installation directory"
    Write-Host "  .\install-windows.ps1 -Uninstall         Uninstall ast-grep"
    Write-Host "  .\install-windows.ps1 -Help              Show this help"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\install-windows.ps1 -AddToPath"
    Write-Host "  .\install-windows.ps1 -InstallPath C:\Tools\ast-grep"
    Write-Host ""
    exit 0
}

# Colors
function Write-Success { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Info { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }

# Check admin rights
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-Host ""
Write-Info "========================================="
Write-Info "ast-grep Windows Installer"
Write-Info "Version: 0.40.0 (Improved Edition)"
Write-Info "========================================="
Write-Host ""

# Handle uninstall
if ($Uninstall) {
    Write-Info "Uninstalling ast-grep..."

    # Remove from PATH
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -like "*ast-grep*") {
        $newPath = ($userPath -split ';' | Where-Object { $_ -notlike "*ast-grep*" }) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Success "✓ Removed from user PATH"
    }

    if (Test-Administrator) {
        $systemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($systemPath -like "*ast-grep*") {
            $newPath = ($systemPath -split ';' | Where-Object { $_ -notlike "*ast-grep*" }) -join ';'
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            Write-Success "✓ Removed from system PATH"
        }
    }

    # Remove installation directory
    if (Test-Path $InstallPath) {
        Remove-Item -Path $InstallPath -Recurse -Force
        Write-Success "✓ Removed installation directory: $InstallPath"
    }

    Write-Success "✓ ast-grep uninstalled successfully"
    Write-Host ""
    exit 0
}

# Check for admin if system-wide
if ($SystemWide -and -not (Test-Administrator)) {
    Write-Error "Error: System-wide installation requires administrator privileges"
    Write-Host "Please run PowerShell as Administrator or use user installation."
    exit 1
}

# Set system-wide path if requested
if ($SystemWide) {
    $InstallPath = "$env:ProgramFiles\ast-grep"
    Write-Info "Installing system-wide to: $InstallPath"
} else {
    Write-Info "Installing to user directory: $InstallPath"
}

# Find binaries
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$astGrepExe = Join-Path $scriptDir "ast-grep.exe"
$sgExe = Join-Path $scriptDir "sg.exe"

# Check if binaries exist
if (-not (Test-Path $astGrepExe)) {
    Write-Error "Error: ast-grep.exe not found!"
    Write-Host "Expected location: $astGrepExe"
    Write-Host ""
    Write-Host "Please ensure the installer is in the same directory as ast-grep.exe"
    Write-Host "Or build the project first using: .\build-windows.ps1 -Release"
    exit 1
}

Write-Success "✓ Found ast-grep.exe"
if (Test-Path $sgExe) {
    Write-Success "✓ Found sg.exe"
}
Write-Host ""

# Create installation directory
Write-Info "Creating installation directory..."
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
Write-Success "✓ Created: $InstallPath"

# Copy binaries
Write-Info "Copying binaries..."
Copy-Item $astGrepExe -Destination $InstallPath -Force
Write-Success "✓ Installed: ast-grep.exe"

if (Test-Path $sgExe) {
    Copy-Item $sgExe -Destination $InstallPath -Force
    Write-Success "✓ Installed: sg.exe"
}

# Copy documentation if available
$readme = Join-Path $scriptDir "README.md"
if (Test-Path $readme) {
    Copy-Item $readme -Destination $InstallPath -Force
    Write-Success "✓ Installed: README.md"
}

$license = Join-Path $scriptDir "LICENSE"
if (Test-Path $license) {
    Copy-Item $license -Destination $InstallPath -Force
    Write-Success "✓ Installed: LICENSE"
}

Write-Host ""

# Add to PATH
if ($AddToPath) {
    Write-Info "Adding to PATH..."

    $scope = if ($SystemWide) { "Machine" } else { "User" }
    $currentPath = [Environment]::GetEnvironmentVariable("Path", $scope)

    # Check if already in PATH
    if ($currentPath -split ';' -contains $InstallPath) {
        Write-Warning "⚠ Already in PATH"
    } else {
        $newPath = "$currentPath;$InstallPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, $scope)
        Write-Success "✓ Added to $scope PATH"
        Write-Warning "⚠ Please restart your terminal for PATH changes to take effect"
    }
} else {
    Write-Warning "⚠ Not added to PATH (use -AddToPath flag)"
    Write-Host ""
    Write-Info "To add to PATH manually:"
    Write-Host "  User PATH:   [Environment]::SetEnvironmentVariable('Path', `$env:Path + ';$InstallPath', 'User')"
    Write-Host "  System PATH: [Environment]::SetEnvironmentVariable('Path', `$env:Path + ';$InstallPath', 'Machine')"
}

Write-Host ""

# Test installation
Write-Info "Testing installation..."
$installedExe = Join-Path $InstallPath "ast-grep.exe"
$version = & $installedExe --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "✓ Installation test passed"
    Write-Host "  Version: $version"
} else {
    Write-Error "✗ Installation test failed"
}

Write-Host ""
Write-Success "========================================="
Write-Success "Installation completed successfully!"
Write-Success "========================================="
Write-Host ""

Write-Info "Installation Details:"
Write-Host "  Location: $InstallPath"
Write-Host "  Binary: ast-grep.exe"
if (Test-Path (Join-Path $InstallPath "sg.exe")) {
    Write-Host "  Alias: sg.exe"
}

Write-Host ""
Write-Info "Usage:"
if ($AddToPath) {
    Write-Host "  ast-grep --help      # Show help (restart terminal first)"
    Write-Host "  sg --help            # Short alias"
} else {
    Write-Host "  $InstallPath\ast-grep.exe --help"
    Write-Host "  $InstallPath\sg.exe --help"
}

Write-Host ""
Write-Info "Quick Start:"
Write-Host "  ast-grep run --pattern 'console.log(`$`$`$)' --lang js"
Write-Host "  ast-grep scan"
Write-Host "  ast-grep --help"

Write-Host ""
Write-Info "Documentation:"
Write-Host "  https://ast-grep.github.io/"

Write-Host ""

# Display next steps
if (-not $AddToPath) {
    Write-Warning "Note: ast-grep is not in your PATH"
    Write-Host "Run this command to add it:"
    Write-Host ""
    Write-Host "  .\install-windows.ps1 -AddToPath"
    Write-Host ""
}
