# ast-grep Windows Build Script
# Version: 0.40.0 (Improved Edition)
# This script builds ast-grep for Windows

param(
    [switch]$Release,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# Display help
if ($Help) {
    Write-Host "ast-grep Windows Build Script"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\build-windows.ps1 -Release    Build release version (optimized)"
    Write-Host "  .\build-windows.ps1             Build debug version"
    Write-Host "  .\build-windows.ps1 -Help       Show this help"
    Write-Host ""
    exit 0
}

# Colors
function Write-Success { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Info { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }

Write-Info "========================================="
Write-Info "ast-grep Windows Build Script"
Write-Info "Version: 0.40.0 (Improved Edition)"
Write-Info "========================================="
Write-Host ""

# Check prerequisites
Write-Info "Checking prerequisites..."

# Check Rust
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Error "Error: Rust/Cargo not found!"
    Write-Host "Please install Rust from: https://rustup.rs/"
    exit 1
}

$rustVersion = cargo --version
Write-Success "✓ Rust installed: $rustVersion"

# Check Git (optional but recommended)
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Success "✓ Git installed: $gitVersion"
} else {
    Write-Warning "⚠ Git not found (optional)"
}

Write-Host ""

# Determine build type
$buildType = if ($Release) { "release" } else { "debug" }
$buildFlag = if ($Release) { "--release" } else { "" }

Write-Info "Build Configuration:"
Write-Host "  Build Type: $buildType"
Write-Host "  Optimizations: $(if ($Release) { 'Enabled (LTO)' } else { 'Disabled' })"
Write-Host ""

# Clean previous builds (optional)
Write-Info "Cleaning previous builds..."
cargo clean 2>&1 | Out-Null
Write-Success "✓ Clean complete"

# Run tests
Write-Info "Running tests..."
$testStart = Get-Date
cargo test --all
if ($LASTEXITCODE -ne 0) {
    Write-Error "✗ Tests failed!"
    exit 1
}
$testDuration = (Get-Date) - $testStart
Write-Success "✓ All tests passed in $([math]::Round($testDuration.TotalSeconds, 2)) seconds"
Write-Host ""

# Build
Write-Info "Building ast-grep..."
$buildStart = Get-Date

if ($Release) {
    cargo build --release
} else {
    cargo build
}

if ($LASTEXITCODE -ne 0) {
    Write-Error "✗ Build failed!"
    exit 1
}

$buildDuration = (Get-Date) - $buildStart
Write-Success "✓ Build completed in $([math]::Round($buildDuration.TotalSeconds, 2)) seconds"
Write-Host ""

# Locate binaries
$targetDir = if ($Release) { "target\release" } else { "target\debug" }
$astGrepExe = Join-Path $targetDir "ast-grep.exe"
$sgExe = Join-Path $targetDir "sg.exe"

if (-not (Test-Path $astGrepExe)) {
    Write-Error "Error: ast-grep.exe not found at $astGrepExe"
    exit 1
}

Write-Success "✓ Binaries built successfully:"
Write-Host "  ast-grep.exe: $(((Get-Item $astGrepExe).Length / 1MB).ToString('F2')) MB"
if (Test-Path $sgExe) {
    Write-Host "  sg.exe: $(((Get-Item $sgExe).Length / 1MB).ToString('F2')) MB"
}
Write-Host ""

# Test binary
Write-Info "Testing binary..."
& $astGrepExe --version
if ($LASTEXITCODE -ne 0) {
    Write-Error "✗ Binary test failed!"
    exit 1
}
Write-Success "✓ Binary test passed"
Write-Host ""

# Create distribution
if ($Release) {
    Write-Info "Creating distribution package..."

    $distDir = "dist\ast-grep-0.40.0-improved-windows-x64"
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null

    # Copy binaries
    Copy-Item $astGrepExe -Destination $distDir
    if (Test-Path $sgExe) {
        Copy-Item $sgExe -Destination $distDir
    }

    # Copy documentation
    if (Test-Path "README.md") {
        Copy-Item "README.md" -Destination $distDir
    }
    if (Test-Path "LICENSE") {
        Copy-Item "LICENSE" -Destination $distDir
    }

    Write-Success "✓ Distribution created at: $distDir"
    Write-Host ""
}

Write-Success "========================================="
Write-Success "Build completed successfully!"
Write-Success "========================================="
Write-Host ""
Write-Info "Binary location: $astGrepExe"

if ($Release) {
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Test the binary: $astGrepExe --help"
    Write-Host "  2. Create installer: .\create-installer.ps1"
    Write-Host "  3. Run installer: .\install-windows.ps1"
}

Write-Host ""
