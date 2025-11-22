# Windows Installation Guide

This directory contains comprehensive build and installation scripts for Windows systems.

## Quick Start

### For Windows Users

1. **Install Rust** (one-time setup)
   - Download from: https://rustup.rs/
   - Run the installer and follow prompts

2. **Build the project**
   ```powershell
   # PowerShell (recommended)
   .\scripts\windows-installer\build-windows.ps1 -Release

   # OR Batch file
   scripts\windows-installer\build-windows.bat --release
   ```

3. **Install**
   ```powershell
   # Copy installer to build directory
   copy scripts\windows-installer\install-windows.ps1 target\release\
   cd target\release

   # Install with automatic PATH setup
   .\install-windows.ps1 -AddToPath
   ```

4. **Verify**
   ```powershell
   # Restart terminal, then:
   ast-grep --version
   ```

## What's Included

### Build Scripts
- **build-windows.ps1** - PowerShell build script (full featured)
- **build-windows.bat** - Batch file alternative

### Installation Scripts
- **install-windows.ps1** - Advanced installer with PATH support
- **install-windows.bat** - Basic installer

### Documentation
- **PACKAGE-README.md** - Quick start guide
- **README-WINDOWS.md** - Complete user guide
- **BUILD-INSTRUCTIONS.md** - Detailed build documentation
- **IMPROVEMENTS.md** - Code quality improvements
- **MANIFEST-WINDOWS.md** - Package manifest

## Features

✅ Automated build with testing
✅ One-command installation
✅ Automatic PATH configuration
✅ User and system-wide options
✅ Comprehensive documentation
✅ Troubleshooting guides

## System Requirements

- Windows 10 (1909+) or Windows 11
- Rust 1.79+ (includes cargo)
- 4-8 GB RAM
- 3 GB disk space

## Support

For detailed instructions, see:
- [PACKAGE-README.md](scripts/windows-installer/PACKAGE-README.md) - Start here
- [README-WINDOWS.md](scripts/windows-installer/README-WINDOWS.md) - Complete guide
- [BUILD-INSTRUCTIONS.md](scripts/windows-installer/BUILD-INSTRUCTIONS.md) - Advanced topics

## Improvements in This Build

This v0.40.0 (Improved Edition) includes code quality enhancements:

- Better error handling
- Improved documentation
- Removed dead code
- Enhanced API safety
- All 446 tests passing

See [IMPROVEMENTS.md](scripts/windows-installer/IMPROVEMENTS.md) for details.

---

**Need help?** Check the documentation files or visit https://ast-grep.github.io/
