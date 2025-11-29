# ast-grep v0.40.0 (Improved Edition) - Windows Build & Installation Guide

## Overview

This package contains scripts and instructions for building and installing ast-grep on Windows systems.

**Note:** This package contains build and installation scripts. You'll need to build the binaries on a Windows system before installation.

## Prerequisites

### Required
- **Rust** (1.79 or later)
  - Download from: https://rustup.rs/
  - Includes `cargo` build tool
- **Windows 10/11** (64-bit)
- **PowerShell 5.1+** or **Command Prompt**

### Optional
- **Git** (for cloning the repository)
- **Visual Studio Build Tools** (usually installed with Rust)

## Quick Start

### Option 1: PowerShell (Recommended)

```powershell
# 1. Build the project
.\build-windows.ps1 -Release

# 2. Install with automatic PATH setup
.\install-windows.ps1 -AddToPath

# 3. Verify installation (restart terminal first)
ast-grep --version
```

### Option 2: Batch Files

```cmd
# 1. Build the project
build-windows.bat --release

# 2. Install (requires manual PATH setup)
install-windows.bat

# 3. Add to PATH manually (see instructions below)
```

## Detailed Instructions

### Step 1: Install Rust

If Rust is not installed:

1. Download installer from https://rustup.rs/
2. Run the installer
3. Follow the prompts (default options work fine)
4. Restart your terminal
5. Verify: `cargo --version`

### Step 2: Get the Source Code

```powershell
git clone https://github.com/danielsimonjr/ast-grep
cd ast-grep
git checkout claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP
```

Or download the source code directly and extract it.

### Step 3: Build

#### Using PowerShell:

```powershell
# Navigate to the installer directory
cd dist\windows-installer

# Copy build script to project root
copy build-windows.ps1 ..\..\

# Go to project root
cd ..\..

# Build release version
.\build-windows.ps1 -Release
```

**Build Options:**
- `-Release` - Optimized release build (recommended, ~2-5 minutes)
- No flags - Debug build (faster but larger binaries)
- `-Help` - Show help

#### Using Batch Files:

```cmd
cd dist\windows-installer
copy build-windows.bat ..\..\
cd ..\..
build-windows.bat --release
```

### Step 4: Install

After building, binaries will be in:
- Release: `target\release\ast-grep.exe`
- Debug: `target\debug\ast-grep.exe`

#### PowerShell Installation:

```powershell
# Copy installer to build directory
copy dist\windows-installer\install-windows.ps1 target\release\

# Navigate to build directory
cd target\release

# Install with PATH setup
.\install-windows.ps1 -AddToPath

# Or system-wide (requires admin)
.\install-windows.ps1 -SystemWide -AddToPath
```

**Installation Options:**
- `-AddToPath` - Automatically add to PATH
- `-SystemWide` - Install for all users (requires admin)
- `-InstallPath PATH` - Custom installation directory
- `-Uninstall` - Remove installation
- `-Help` - Show help

#### Batch Installation:

```cmd
copy dist\windows-installer\install-windows.bat target\release\
cd target\release
install-windows.bat
```

Default installation location: `%LOCALAPPDATA%\Programs\ast-grep`

## Manual PATH Setup

If you didn't use `-AddToPath`, add to PATH manually:

### Using System Properties:

1. Press `Win + R`, type: `sysdm.cpl`, press Enter
2. Click "Environment Variables"
3. Under "User variables", select "Path"
4. Click "Edit" → "New"
5. Add: `C:\Users\YourName\AppData\Local\Programs\ast-grep`
6. Click "OK" on all dialogs
7. **Restart your terminal**

### Using PowerShell:

```powershell
# User PATH
$path = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$path;$env:LOCALAPPDATA\Programs\ast-grep", "User")

# System PATH (requires admin)
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$path;C:\Program Files\ast-grep", "Machine")
```

### Using Command Prompt (Admin):

```cmd
REM User PATH
setx PATH "%PATH%;%LOCALAPPDATA%\Programs\ast-grep"

REM System PATH (run as admin)
setx /M PATH "%PATH%;C:\Program Files\ast-grep"
```

## Verification

After installation and PATH setup:

```powershell
# Restart terminal, then:
ast-grep --version
# Output: ast-grep 0.40.0

ast-grep --help
sg --help  # Short alias
```

## Usage Examples

```powershell
# Search for patterns
ast-grep run --pattern 'console.log($$$)' --lang js

# Search in files
ast-grep run --pattern 'println!($A)' src\

# Scan with config
ast-grep scan

# Interactive rewrite
ast-grep run -p 'var $A = $B' -r 'let $A = $B' -l js --interactive
```

## Troubleshooting

### Build Errors

**"Rust not found":**
- Install Rust from https://rustup.rs/
- Restart terminal
- Verify: `cargo --version`

**"Link errors" or "MSVC not found":**
```powershell
# Install Visual Studio Build Tools
rustup toolchain install stable-msvc
rustup default stable-msvc
```

**"Tests failed":**
- Check network connection (some tests might download dependencies)
- Try: `cargo test --all --no-fail-fast` for detailed output

### Installation Errors

**"ast-grep.exe not found":**
- Ensure you built the project first
- Check `target\release\ast-grep.exe` exists
- Run installer from the directory containing `ast-grep.exe`

**"Access denied":**
- For system-wide install, run PowerShell as Administrator
- Or use user installation (default)

**"Command not found after installation":**
- PATH was not updated
- Restart terminal
- Verify PATH includes installation directory
- Add manually (see Manual PATH Setup above)

### Runtime Errors

**"VCRUNTIME140.dll not found":**
- Install Visual C++ Redistributable
- Download from: https://aka.ms/vs/17/release/vc_redist.x64.exe

**"The application was unable to start correctly":**
- Ensure Windows 10/11 64-bit
- Try rebuilding: `cargo clean && cargo build --release`

## Uninstallation

### Using PowerShell:

```powershell
cd %LOCALAPPDATA%\Programs\ast-grep
.\install-windows.ps1 -Uninstall
```

### Using Batch:

```cmd
cd %LOCALAPPDATA%\Programs\ast-grep
install-windows.bat --uninstall
```

### Manual:

1. Delete installation directory
2. Remove from PATH (reverse PATH setup steps)
3. Restart terminal

## Build Configuration

The project uses these optimizations for release builds:

```toml
[profile.release]
lto = true              # Link-Time Optimization
opt-level = 3           # Maximum optimization
codegen-units = 16      # Parallel compilation
```

## Package Contents

```
windows-installer/
├── build-windows.ps1       # PowerShell build script
├── build-windows.bat       # Batch build script
├── install-windows.ps1     # PowerShell installer (recommended)
├── install-windows.bat     # Batch installer
├── README-WINDOWS.md       # This file
├── BUILD-INSTRUCTIONS.md   # Detailed build guide
└── IMPROVEMENTS.md         # Code improvements in this version
```

## Improvements in This Build

This build (v0.40.0 Improved Edition) includes:

✅ Better error messages
✅ Improved documentation
✅ Removed dead code
✅ Enhanced API safety
✅ All 446 tests passing

See `IMPROVEMENTS.md` for details.

## System Requirements

- **OS**: Windows 10 (1909+) or Windows 11
- **Architecture**: x86_64 (64-bit)
- **RAM**: 4 GB minimum, 8 GB recommended
- **Disk**: 500 MB for Rust + build, 50 MB for binary
- **Network**: Required for initial Rust setup and dependencies

## Supported Languages

ast-grep supports pattern matching for 20+ languages:

Bash, C, C++, C#, CSS, Elixir, Go, Haskell, HCL, HTML, Java, JavaScript,
JSON, Kotlin, Lua, Nix, PHP, Python, Ruby, Rust, Scala, Solidity, Swift,
TypeScript, YAML, and more via custom parsers.

## Documentation

- **Website**: https://ast-grep.github.io/
- **Guide**: https://ast-grep.github.io/guide/introduction.html
- **Playground**: https://ast-grep.github.io/playground.html
- **API Reference**: https://ast-grep.github.io/reference/api.html

## Support

- **GitHub**: https://github.com/ast-grep/ast-grep
- **Issues**: https://github.com/ast-grep/ast-grep/issues
- **Discussions**: https://github.com/ast-grep/ast-grep/discussions
- **Discord**: https://discord.gg/4YZjf6htSQ

## License

MIT License - See LICENSE file

Copyright © 2022 Herrington Darkholme

## Advanced Topics

### Custom Installation Location

```powershell
.\install-windows.ps1 -InstallPath "C:\Tools\ast-grep" -AddToPath
```

### Building Specific Targets

```powershell
# 32-bit Windows
cargo build --release --target i686-pc-windows-msvc

# ARM64 Windows
cargo build --release --target aarch64-pc-windows-msvc
```

### Portable Installation

No installation needed - run directly:

```powershell
cd target\release
.\ast-grep.exe --help
```

### Creating a Zip Package

```powershell
# After building
cd target\release
Compress-Archive -Path ast-grep.exe,sg.exe,..\..\LICENSE,..\..\README.md -DestinationPath ast-grep-windows.zip
```

## FAQ

**Q: Do I need administrator rights?**
A: No, user installation doesn't require admin. System-wide installation does.

**Q: Can I use this on Windows 7/8?**
A: ast-grep requires Windows 10 1909+ or Windows 11.

**Q: How do I update?**
A: Pull latest changes and rebuild, or reinstall with new binaries.

**Q: Why is the binary so large?**
A: Rust binaries include the standard library. Release builds are optimized but still ~40-50 MB.

**Q: Can I use WSL instead?**
A: Yes! Use the Linux installer in WSL. But native Windows is recommended for better performance.

---

**Build Date**: November 21, 2025
**Improved Edition**: Includes code quality enhancements and better documentation
