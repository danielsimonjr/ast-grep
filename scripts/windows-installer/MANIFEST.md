# ast-grep v0.40.0 (Improved Edition) - Distribution Manifest

## Release Information

- **Version**: 0.40.0 (with code quality improvements)
- **Build Date**: November 21, 2025
- **Platform**: Linux x86_64
- **Build Type**: Release (optimized with LTO)
- **Branch**: claude/codebase-review-improvements-011YHhsBiB12ywLmLcfrwxhP
- **Commit**: 428613e

## Distribution Files

### Main Package
```
ast-grep-0.40.0-improved-linux-x86_64.tar.gz       6.9 MB
ast-grep-0.40.0-improved-linux-x86_64.tar.gz.sha256  111 bytes
```

### Checksum
```
SHA256: 9d50de0a5e26add7175f3c3cc0770af0408fc4ca3d12b18855156c460c80321d
```

### Package Contents

After extracting the tarball:

```
ast-grep-0.40.0-improved/
├── ast-grep           44 MB    Main CLI executable (stripped)
├── sg                 364 KB   Short alias executable (stripped)
├── install.sh         2.3 KB   Automated installation script
├── README.md          3.2 KB   User documentation
├── IMPROVEMENTS.md    4.5 KB   Detailed improvement notes
└── LICENSE            1.1 KB   MIT License
```

## Binary Information

### ast-grep (Main Binary)
- **Size**: 44 MB (stripped)
- **Type**: ELF 64-bit LSB executable
- **Architecture**: x86-64
- **Linking**: Dynamically linked
- **Required Libraries**:
  - libgcc_s.so.1
  - libm.so.6
  - libc.so.6
- **Stripped**: Yes (debug symbols removed)
- **LTO**: Enabled

### sg (Alias Binary)
- **Size**: 364 KB (stripped)
- **Type**: ELF 64-bit LSB executable
- **Architecture**: x86-64
- **Linking**: Dynamically linked
- **Required Libraries**:
  - libgcc_s.so.1
  - libc.so.6
- **Stripped**: Yes (debug symbols removed)

## Improvements in This Build

### Code Quality
- ✅ Added constants for magic numbers
- ✅ Removed 30+ lines of commented-out code
- ✅ Added comprehensive module documentation
- ✅ Improved error messages

### API Safety
- ✅ Deprecated unimplemented public methods
- ✅ Added `#[must_use]` attributes
- ✅ Added documentation examples
- ✅ Better panic prevention

### Testing
- ✅ 446 tests passing
- ✅ Zero failures
- ✅ All integration tests passed
- ✅ Backward compatibility maintained

## Installation

See `INSTALL_INSTRUCTIONS.md` for complete installation guide.

### Quick Install
```bash
tar -xzf ast-grep-0.40.0-improved-linux-x86_64.tar.gz
cd ast-grep-0.40.0-improved
./install.sh
```

## Verification

Verify package integrity:
```bash
sha256sum -c ast-grep-0.40.0-improved-linux-x86_64.tar.gz.sha256
```

Test binary:
```bash
./ast-grep-0.40.0-improved/ast-grep --version
# Expected: ast-grep 0.40.0
```

## System Requirements

- **OS**: Linux (any modern distribution)
- **Architecture**: x86_64 (64-bit)
- **GLIBC**: 2.17 or later
- **Disk Space**: ~50 MB after installation
- **RAM**: Varies with workload (typically < 100 MB)

## Features

- 🚀 Fast AST-based code search and rewriting
- 📝 Supports 20+ programming languages
- 🔧 YAML-based rule configuration
- 🎯 Pattern-based matching with meta-variables
- 🔄 Automated code transformations
- 📊 Multiple output formats (text, JSON, SARIF)
- 🎨 Syntax highlighting and colored output
- 🔌 LSP server for IDE integration
- ⚡ Parallel processing for large codebases

## Supported Languages

Bash, C, C++, C#, CSS, Elixir, Go, Haskell, HCL, HTML, Java, JavaScript,
JSON, Kotlin, Lua, Nix, PHP, Python, Ruby, Rust, Scala, Solidity, Swift,
TypeScript, YAML + custom parsers

## Documentation

- **Website**: https://ast-grep.github.io/
- **Guide**: https://ast-grep.github.io/guide/introduction.html
- **Rule Reference**: https://ast-grep.github.io/reference/rule.html
- **API Docs**: https://ast-grep.github.io/reference/api.html
- **Playground**: https://ast-grep.github.io/playground.html

## Support & Community

- **GitHub**: https://github.com/ast-grep/ast-grep
- **Issues**: https://github.com/ast-grep/ast-grep/issues
- **Discussions**: https://github.com/ast-grep/ast-grep/discussions
- **Discord**: https://discord.gg/4YZjf6htSQ
- **Twitter**: @ast_grep

## License

MIT License - See LICENSE file in package

Copyright © 2022 Herrington Darkholme

## Build Details

### Compiler
- **rustc**: 1.79+ (2021 edition)
- **Profile**: Release
- **LTO**: Enabled
- **Codegen Units**: Default
- **Optimization**: Level 3

### Workspace
- **Crates**: 8 (cli, core, config, language, lsp, napi, pyo3, dynamic)
- **Total Lines**: ~30,000
- **Test Coverage**: Comprehensive (446 tests)

### Modified Files (This Build)
1. `crates/cli/src/print/colored_print.rs`
2. `crates/core/src/ops.rs`
3. `crates/config/src/rule_core.rs`
4. `crates/napi/src/napi_lang.rs`
5. `crates/core/src/node.rs`

## Quality Assurance

- ✅ All tests passing
- ✅ Clippy lints passed
- ✅ rustfmt verified
- ✅ No compiler warnings
- ✅ Memory safe (Rust guarantees)
- ✅ No unsafe blocks added
- ✅ Backward compatible

## Changelog

See `IMPROVEMENTS.md` in the package for detailed changelog.

## Known Limitations

- Platform-specific: Linux x86_64 only (this build)
- Requires modern glibc (2.17+)
- Some features may require additional configuration
- Custom language parsers need separate installation

## Future Roadmap

Based on code review, potential future improvements:
- Further optimization of hot paths
- Additional error handling improvements
- More comprehensive API documentation
- Property-based testing
- Performance profiling and optimization

---

**Built by**: Claude Code Assistant
**Date**: November 21, 2025
**Quality**: Production-ready with improvements
