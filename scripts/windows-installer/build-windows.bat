@echo off
REM ast-grep Windows Build Script (Batch)
REM Version: 0.40.0 (Improved Edition)

echo =========================================
echo ast-grep Windows Build Script
echo Version: 0.40.0 (Improved Edition)
echo =========================================
echo.

REM Check for Rust/Cargo
where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Rust/Cargo not found!
    echo Please install Rust from: https://rustup.rs/
    exit /b 1
)

echo [OK] Rust/Cargo found
cargo --version
echo.

REM Parse arguments
set BUILD_TYPE=debug
set BUILD_FLAG=

if "%1"=="--release" (
    set BUILD_TYPE=release
    set BUILD_FLAG=--release
)
if "%1"=="-r" (
    set BUILD_TYPE=release
    set BUILD_FLAG=--release
)

echo Build Type: %BUILD_TYPE%
echo.

REM Run tests
echo Running tests...
cargo test --all
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Tests failed!
    exit /b 1
)
echo [OK] All tests passed
echo.

REM Build
echo Building ast-grep...
cargo build %BUILD_FLAG%
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Build failed!
    exit /b 1
)
echo [OK] Build completed
echo.

REM Test binary
echo Testing binary...
target\%BUILD_TYPE%\ast-grep.exe --version
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Binary test failed!
    exit /b 1
)
echo [OK] Binary test passed
echo.

echo =========================================
echo Build completed successfully!
echo =========================================
echo.
echo Binary location: target\%BUILD_TYPE%\ast-grep.exe
echo.
echo Next steps:
echo   1. Test: target\%BUILD_TYPE%\ast-grep.exe --help
echo   2. Install: install-windows.bat
echo.
