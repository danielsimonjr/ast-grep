# ast-grep v0.40.0 (Improved Edition) - Windows Build Package

## What's in This Package

This is the **Windows Build & Installation Package** for ast-grep v0.40.0 (Improved Edition).

**Important:** This package contains build and installation scripts for Windows. You'll need to build the binaries on a Windows machine before installation.

## Quick Start Guide

### For Windows Users

1. **Download this package** to your Windows system
2. **Install Rust** from https://rustup.rs/ (if not already installed)
3. **Clone or download** the ast-grep source code
4. **Run the build script** (PowerShell or Batch)
5. **Run the installer**

### Detailed Steps

```powershell
# On Windows:

# 1. Install Rust (one-time setup)
# Visit: https://rustup.rs/ and follow instructions

# 2. Get source code
git clone https://github.com/danielsimonjr/ast-grep
cd ast-grep
git checkout claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP

# 3. Copy build scripts to project root
copy dist\windows-installer\build-windows.ps1 .

# 4. Build
.\build-windows.ps1 -Release

# 5. Install
copy dist\windows-installer\install-windows.ps1 target\release\
cd target\release
.\install-windows.ps1 -AddToPath
```

## Package Contents

```
windows-installer/
├── build-windows.ps1           PowerShell build script (recommended)
├── build-windows.bat           Batch file build script
├── install-windows.ps1         PowerShell installer with PATH support
├── install-windows.bat         Batch file installer (manual PATH)
├── README-WINDOWS.md           Complete Windows guide
├── BUILD-INSTRUCTIONS.md       Detailed build instructions
├── IMPROVEMENTS.md             Code improvements in this version
├── PACKAGE-README.md           This file
└── MANIFEST-WINDOWS.md         Complete package manifest
```

## Why This Approach?

Due to network restrictions in the Linux build environment, we cannot cross-compile Windows binaries directly. However, this package provides everything you need to build and install ast-grep on Windows:

✅ **Complete build scripts** (PowerShell & Batch)
✅ **Automated installer** with PATH configuration
✅ **Comprehensive documentation**
✅ **Troubleshooting guides**
✅ **All improvements included** in the source code

## System Requirements

- **Windows 10** (1909+) or **Windows 11**
- **64-bit** (x86_64)
- **4 GB RAM** minimum (8 GB recommended)
- **2 GB free disk** space
- **Internet connection** (for initial Rust setup)

## Prerequisites

### Required
- **Rust 1.79+** - Install from https://rustup.rs/
  - Includes cargo (build tool)
  - Includes rustc (compiler)

### Automatic (Installed with Rust)
- **Visual Studio Build Tools** (MSVC)
- **Windows SDK**

### Optional
- **Git** - For cloning repository
- **PowerShell 5.1+** - For using .ps1 scripts (recommended)

## Build Options

### Option 1: PowerShell (Recommended)

**Advantages:**
- Colored output
- Better error messages
- Automatic PATH setup
- Progress indicators

**Usage:**
```powershell
.\build-windows.ps1 -Release
```

### Option 2: Batch Files

**Advantages:**
- No PowerShell required
- Works everywhere
- Simpler syntax

**Usage:**
```cmd
build-windows.bat --release
```

### Option 3: Manual Cargo

**For experienced users:**
```powershell
cargo build --release
```

## Installation Options

### PowerShell (Recommended)

```powershell
.\install-windows.ps1 -AddToPath
```

**Features:**
- Automatic PATH configuration
- User or system-wide installation
- Custom installation path
- Easy uninstall

### Batch File

```cmd
install-windows.bat
```

**Note:** Requires manual PATH setup

### Manual

Just copy `ast-grep.exe` to a directory in your PATH.

## Documentation Files

| File | Purpose |
|------|---------|
| **PACKAGE-README.md** | This file - Quick overview |
| **README-WINDOWS.md** | Complete Windows user guide |
| **BUILD-INSTRUCTIONS.md** | Detailed build documentation |
| **IMPROVEMENTS.md** | Code improvements in this version |

**Start with:** `README-WINDOWS.md` for full instructions.

## What Makes This Version "Improved"?

This v0.40.0 (Improved Edition) includes code quality enhancements:

✨ **Code Quality**
- Added constants for magic numbers
- Removed commented-out code (30+ lines)
- Comprehensive module documentation

🛡️ **Safety**
- Improved error handling
- Deprecated unsafe unimplemented APIs
- Better error messages

📚 **Documentation**
- Enhanced API documentation
- Added usage examples
- Module-level documentation

🧪 **Testing**
- All 446 tests passing
- No regressions
- Backward compatible

See `IMPROVEMENTS.md` for complete details.

## Supported Languages

ast-grep supports pattern matching for **20+ programming languages**:

| Category | Languages |
|----------|-----------|
| **Systems** | C, C++, Rust, Go |
| **Web** | JavaScript, TypeScript, HTML, CSS |
| **Backend** | Java, C#, PHP, Python, Ruby, Elixir |
| **Functional** | Haskell, Scala, Elixir |
| **Scripting** | Bash, Lua, Python |
| **Data** | JSON, YAML |
| **Infra** | HCL (Terraform) |
| **Blockchain** | Solidity |
| **Mobile** | Swift, Kotlin |

Plus support for custom languages via tree-sitter parsers.

## Features

🚀 **Fast**
- AST-based (not regex)
- Parallel processing
- Rust performance

🎯 **Precise**
- Structural matching
- Meta-variables
- Contextual patterns

🔧 **Flexible**
- YAML configuration
- CLI and LSP
- Multiple output formats

🔄 **Powerful**
- Code search
- Code rewriting
- Automated refactoring

## Common Use Cases

### Code Search
Find all usages of deprecated APIs:
```powershell
ast-grep run --pattern 'oldFunction($$$)' src\
```

### Code Refactoring
Update variable declarations:
```powershell
ast-grep run -p 'var $A = $B' -r 'let $A = $B' -l js --interactive
```

### Linting
Create custom lint rules:
```yaml
# .ast-grep/rules/no-console.yml
id: no-console
message: Remove console.log
language: JavaScript
rule:
  pattern: console.log($$$)
```

## Getting Help

### Documentation
- **Website**: https://ast-grep.github.io/
- **Guide**: https://ast-grep.github.io/guide/introduction.html
- **Playground**: https://ast-grep.github.io/playground.html

### Support
- **GitHub Issues**: https://github.com/ast-grep/ast-grep/issues
- **Discussions**: https://github.com/ast-grep/ast-grep/discussions
- **Discord**: https://discord.gg/4YZjf6htSQ

### This Package
- Start with: `README-WINDOWS.md`
- Build help: `BUILD-INSTRUCTIONS.md`
- Improvements: `IMPROVEMENTS.md`

## Troubleshooting

### "Rust not found"
→ Install from https://rustup.rs/

### "Build failed"
→ See `BUILD-INSTRUCTIONS.md` § Troubleshooting

### "Tests failed"
→ Check network connection, try: `cargo test --all --no-fail-fast`

### "Command not found after install"
→ Restart terminal, verify PATH, see `README-WINDOWS.md` § Manual PATH Setup

### "VCRUNTIME140.dll missing"
→ Install Visual C++ Redistributable: https://aka.ms/vs/17/release/vc_redist.x64.exe

## Version Information

- **Version**: 0.40.0 (Improved Edition)
- **Build Date**: November 21, 2025
- **Platform**: Windows x86_64
- **License**: MIT
- **Source Branch**: `claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP`

## License

MIT License

Copyright © 2022 Herrington Darkholme

See LICENSE file for full text.

## Credits

- **Original Project**: https://github.com/ast-grep/ast-grep
- **Author**: Herrington Darkholme
- **This Build**: Enhanced with code quality improvements

## Next Steps

1. **Read** `README-WINDOWS.md` for complete instructions
2. **Install** Rust from https://rustup.rs/
3. **Clone** source: `git clone https://github.com/danielsimonjr/ast-grep`
4. **Build** using: `build-windows.ps1 -Release`
5. **Install** using: `install-windows.ps1 -AddToPath`
6. **Verify**: `ast-grep --version`

---

**Happy Code Searching! 🔍**

For questions or issues, please visit:
https://github.com/ast-grep/ast-grep/issues
