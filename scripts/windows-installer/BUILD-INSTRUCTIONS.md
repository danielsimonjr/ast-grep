# Comprehensive Build Instructions for Windows

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Building from Source](#building-from-source)
4. [Creating Distribution Package](#creating-distribution-package)
5. [Testing](#testing)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

#### 1. Rust Toolchain

**Installation:**
```powershell
# Download and run from https://rustup.rs/
# Or use winget:
winget install Rustlang.Rustup
```

**Verification:**
```powershell
rustc --version  # Should show 1.79 or later
cargo --version
rustup --version
```

**Components:**
```powershell
rustup component add rustfmt clippy
```

#### 2. Visual Studio Build Tools

Rust on Windows requires MSVC (Microsoft Visual C++) Build Tools.

**Option A: Visual Studio (Full)**
- Download Visual Studio Community (free)
- Select "Desktop development with C++" workload

**Option B: Build Tools Only (Recommended)**
```powershell
# During Rust installation, choose option 1
# This will prompt to install Visual Studio Build Tools

# Or download manually:
# https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
```

#### 3. Git (Optional but Recommended)

```powershell
winget install Git.Git
# Or download from: https://git-scm.com/download/win
```

### System Requirements

- **OS**: Windows 10 (version 1909 or later) or Windows 11
- **Architecture**: x86_64 (64-bit)
- **RAM**: 8 GB (minimum 4 GB)
- **Disk Space**:
  - 2 GB for Rust toolchain
  - 1 GB for build artifacts
  - 500 MB for dependencies
  - 50 MB for final binary
- **Internet**: Required for initial setup

## Environment Setup

### 1. Configure Rust

```powershell
# Ensure using stable channel
rustup default stable

# Update to latest
rustup update

# Verify target is installed
rustup target list --installed
# Should show: x86_64-pc-windows-msvc
```

### 2. Set Environment Variables (Optional)

For better build performance:

```powershell
# Increase parallel jobs
$env:CARGO_BUILD_JOBS = "8"  # Adjust based on CPU cores

# Use faster linker (if you have LLVM installed)
$env:RUSTFLAGS = "-C link-arg=-fuse-ld=lld"
```

### 3. Configure Cargo (Optional)

Create or edit `~\.cargo\config.toml`:

```toml
[build]
jobs = 8  # Parallel compilation

[profile.release]
lto = true
opt-level = 3
codegen-units = 16

[net]
git-fetch-with-cli = true  # Use system git for better auth
```

## Building from Source

### Method 1: Using PowerShell Script (Recommended)

```powershell
# Clone repository
git clone https://github.com/danielsimonjr/ast-grep
cd ast-grep
git checkout claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP

# Copy build script
copy dist\windows-installer\build-windows.ps1 .

# Build release version
.\build-windows.ps1 -Release
```

**Build Output:**
- Binaries: `target\release\ast-grep.exe` and `target\release\sg.exe`
- Build time: 2-5 minutes (depending on hardware)
- Size: ~40-50 MB (ast-grep.exe), ~400 KB (sg.exe)

### Method 2: Using Batch Script

```cmd
git clone https://github.com/danielsimonjr/ast-grep
cd ast-grep
git checkout claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP

copy dist\windows-installer\build-windows.bat .
build-windows.bat --release
```

### Method 3: Manual Build

```powershell
# Clean previous builds
cargo clean

# Run tests
cargo test --all
# Expected: 446 tests passed

# Build release
cargo build --release
# Binaries in: target\release\

# Verify
target\release\ast-grep.exe --version
# Output: ast-grep 0.40.0
```

### Build Configurations

#### Debug Build (Faster compilation, larger binary)
```powershell
cargo build
# Output: target\debug\ast-grep.exe
```

#### Release Build (Optimized, smaller binary)
```powershell
cargo build --release
# Output: target\release\ast-grep.exe
```

#### Release with Strip (Smallest binary)
```powershell
cargo build --release
strip target\release\ast-grep.exe
strip target\release\sg.exe
```

## Creating Distribution Package

### Automated Package Creation

```powershell
# After successful build
cd target\release

# Create distribution directory
$dist = "ast-grep-0.40.0-windows-x64"
New-Item -ItemType Directory -Force -Path $dist

# Copy binaries
Copy-Item ast-grep.exe, sg.exe -Destination $dist\

# Copy documentation
Copy-Item ..\..\LICENSE, ..\..\README.md -Destination $dist\

# Copy installer scripts
Copy-Item ..\..\dist\windows-installer\install-windows.ps1 -Destination $dist\
Copy-Item ..\..\dist\windows-installer\install-windows.bat -Destination $dist\
Copy-Item ..\..\dist\windows-installer\README-WINDOWS.md -Destination $dist\

# Create zip archive
Compress-Archive -Path $dist -DestinationPath "$dist.zip" -Force

Write-Host "Package created: $dist.zip"
```

### Manual Package Creation

1. Create folder: `ast-grep-0.40.0-windows-x64`
2. Copy files:
   - `ast-grep.exe`
   - `sg.exe`
   - `LICENSE`
   - `README.md`
   - `install-windows.ps1`
   - `install-windows.bat`
3. Zip the folder

### Package Structure

```
ast-grep-0.40.0-windows-x64/
├── ast-grep.exe              # Main binary (~40 MB)
├── sg.exe                    # Short alias (~400 KB)
├── LICENSE                   # MIT License
├── README.md                 # User documentation
├── README-WINDOWS.md         # Windows-specific guide
├── install-windows.ps1       # PowerShell installer
└── install-windows.bat       # Batch installer
```

## Testing

### Basic Functionality Test

```powershell
cd target\release

# Version check
.\ast-grep.exe --version

# Help command
.\ast-grep.exe --help

# Pattern matching test
echo 'fn main() { println!("test"); }' | .\ast-grep.exe run --pattern 'println!($A)' -l rust

# Expected output should show match
```

### Comprehensive Test Suite

```powershell
# Run all tests
cargo test --all

# Run specific test category
cargo test --package ast-grep-cli
cargo test --package ast-grep-core

# Run with output
cargo test --all -- --nocapture

# Run benchmark tests
cargo test --all --features bench
```

### Performance Test

```powershell
# Time a simple search
Measure-Command {
    .\target\release\ast-grep.exe run --pattern 'fn $NAME($$$)' src\
}
```

### Integration Test

Create `test-search.ps1`:

```powershell
$testFile = "test.rs"
@"
fn hello() { println!("Hello"); }
fn world() { println!("World"); }
"@ | Out-File $testFile

$result = .\target\release\ast-grep.exe run --pattern 'println!($A)' $testFile

if ($result -match "Hello" -and $result -match "World") {
    Write-Host "✓ Integration test passed" -ForegroundColor Green
} else {
    Write-Host "✗ Integration test failed" -ForegroundColor Red
}

Remove-Item $testFile
```

## Troubleshooting

### Build Issues

#### "linker 'link.exe' not found"

**Cause**: MSVC Build Tools not installed

**Solution**:
```powershell
# Install Visual Studio Build Tools
# Visit: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022

# Or reinstall Rust and select MSVC toolchain
rustup toolchain install stable-msvc
rustup default stable-msvc
```

#### "note: LINK : fatal error LNK1104: cannot open file 'msvcrt.lib'"

**Cause**: Windows SDK not properly configured

**Solution**:
```powershell
# Reinstall Visual Studio Build Tools
# Ensure "Windows 10 SDK" is selected during installation

# Or repair installation:
# Control Panel → Programs → Visual Studio Build Tools → Modify
```

#### "error: could not compile ..."

**Cause**: Dependency issues or network problems

**Solution**:
```powershell
# Clear cargo cache
cargo clean
Remove-Item -Recurse -Force ~\.cargo\registry\cache
Remove-Item -Recurse -Force ~\.cargo\git\db

# Update dependencies
cargo update

# Retry build
cargo build --release
```

#### Out of Memory Error

**Cause**: Insufficient RAM for parallel compilation

**Solution**:
```powershell
# Reduce parallel jobs
$env:CARGO_BUILD_JOBS = "2"
cargo build --release
```

### Test Issues

#### "test result: FAILED. X passed; Y failed"

**Solution**:
```powershell
# Run failed tests with details
cargo test --all -- --nocapture --test-threads=1

# Check specific failing test
cargo test test_name -- --nocapture
```

#### Network-related Test Failures

**Solution**:
```powershell
# Some tests might require network access
# Check firewall/antivirus settings

# Or skip network tests
cargo test --all --offline
```

### Runtime Issues

#### "VCRUNTIME140.dll was not found"

**Solution**:
```powershell
# Install Visual C++ Redistributable
# Download from:
# https://aka.ms/vs/17/release/vc_redist.x64.exe
```

#### "The code execution cannot proceed because MSVCP140.dll was not found"

**Solution**:
Same as above - install Visual C++ Redistributable

### Performance Issues

#### Slow Build Times

**Solutions**:
```powershell
# 1. Use faster linker (requires LLVM/Clang)
$env:RUSTFLAGS = "-C link-arg=-fuse-ld=lld"

# 2. Increase parallel jobs
$env:CARGO_BUILD_JOBS = "8"

# 3. Use incremental compilation (debug builds)
# Already enabled by default

# 4. Use SSD for build directory

# 5. Exclude build directory from antivirus
```

#### Binary Size Too Large

**Solutions**:
```powershell
# 1. Strip debug symbols
strip target\release\ast-grep.exe

# 2. Use UPX compression (optional)
# Download UPX from: https://upx.github.io/
upx --best --lzma target\release\ast-grep.exe

# 3. Enable additional optimizations
# Add to Cargo.toml:
# [profile.release]
# strip = true
# opt-level = "z"  # Optimize for size
```

## Advanced Build Options

### Cross-Compilation

Build for other Windows architectures:

```powershell
# 32-bit Windows
rustup target add i686-pc-windows-msvc
cargo build --release --target i686-pc-windows-msvc

# ARM64 Windows
rustup target add aarch64-pc-windows-msvc
cargo build --release --target aarch64-pc-windows-msvc
```

### Custom Features

```powershell
# Build with specific features
cargo build --release --features "feature1,feature2"

# Build without default features
cargo build --release --no-default-features
```

### Profile-Guided Optimization (PGO)

For maximum performance:

```powershell
# 1. Build instrumented binary
$env:RUSTFLAGS = "-Cprofile-generate=pgo-data"
cargo build --release

# 2. Run typical workloads
.\target\release\ast-grep.exe run --pattern 'fn $NAME($$$)' src\

# 3. Merge profile data
llvm-profdata merge -o pgo-data\merged.profdata pgo-data\

# 4. Build optimized binary
$env:RUSTFLAGS = "-Cprofile-use=pgo-data\merged.profdata"
cargo build --release
```

## Continuous Integration

Example GitHub Actions workflow:

```yaml
name: Windows Build

on: [push, pull_request]

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          profile: minimal
      - name: Build
        run: cargo build --release
      - name: Test
        run: cargo test --all
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: ast-grep-windows
          path: target/release/ast-grep.exe
```

## Conclusion

You should now be able to:
- ✅ Set up build environment
- ✅ Build from source
- ✅ Run tests
- ✅ Create distribution packages
- ✅ Troubleshoot common issues

For further assistance:
- Documentation: https://ast-grep.github.io/
- Issues: https://github.com/ast-grep/ast-grep/issues
- Discord: https://discord.gg/4YZjf6htSQ

---

**Last Updated**: November 21, 2025
**Version**: 0.40.0 (Improved Edition)
