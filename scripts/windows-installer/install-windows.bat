@echo off
REM ast-grep Windows Installer (Batch)
REM Version: 0.40.0 (Improved Edition)

setlocal enabledelayedexpansion

echo.
echo =========================================
echo ast-grep Windows Installer
echo Version: 0.40.0 (Improved Edition)
echo =========================================
echo.

REM Default installation path
set "INSTALL_PATH=%LOCALAPPDATA%\Programs\ast-grep"

REM Parse command line arguments
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="--uninstall" goto :uninstall
if not "%1"=="" set "INSTALL_PATH=%1"

REM Check if binaries exist
if not exist "ast-grep.exe" (
    echo [ERROR] ast-grep.exe not found in current directory!
    echo.
    echo Please ensure this installer is in the same directory as ast-grep.exe
    echo Or build the project first using: build-windows.bat --release
    echo.
    exit /b 1
)

echo [OK] Found ast-grep.exe
if exist "sg.exe" echo [OK] Found sg.exe
echo.

REM Create installation directory
echo Creating installation directory...
if not exist "%INSTALL_PATH%" mkdir "%INSTALL_PATH%"
echo [OK] Created: %INSTALL_PATH%
echo.

REM Copy binaries
echo Installing binaries...
copy /Y "ast-grep.exe" "%INSTALL_PATH%\" >nul
echo [OK] Installed: ast-grep.exe

if exist "sg.exe" (
    copy /Y "sg.exe" "%INSTALL_PATH%\" >nul
    echo [OK] Installed: sg.exe
)

REM Copy documentation
if exist "README.md" (
    copy /Y "README.md" "%INSTALL_PATH%\" >nul
    echo [OK] Installed: README.md
)

if exist "LICENSE" (
    copy /Y "LICENSE" "%INSTALL_PATH%\" >nul
    echo [OK] Installed: LICENSE
)

echo.

REM Test installation
echo Testing installation...
"%INSTALL_PATH%\ast-grep.exe" --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Installation test passed
    "%INSTALL_PATH%\ast-grep.exe" --version
) else (
    echo [FAIL] Installation test failed
)

echo.
echo =========================================
echo Installation completed successfully!
echo =========================================
echo.
echo Installation Details:
echo   Location: %INSTALL_PATH%
echo   Binary: ast-grep.exe
if exist "%INSTALL_PATH%\sg.exe" echo   Alias: sg.exe
echo.
echo IMPORTANT: Add to PATH
echo   To use 'ast-grep' from anywhere, add this directory to your PATH:
echo   %INSTALL_PATH%
echo.
echo Manual PATH Instructions:
echo   1. Press Win + R, type: sysdm.cpl
echo   2. Click "Environment Variables"
echo   3. Under "User variables", select "Path"
echo   4. Click "Edit" -^> "New"
echo   5. Add: %INSTALL_PATH%
echo   6. Click "OK" on all dialogs
echo   7. Restart your terminal
echo.
echo Or run PowerShell installer with -AddToPath flag:
echo   powershell -ExecutionPolicy Bypass -File install-windows.ps1 -AddToPath
echo.
echo Usage:
echo   %INSTALL_PATH%\ast-grep.exe --help
echo   %INSTALL_PATH%\sg.exe --help
echo.
echo Documentation: https://ast-grep.github.io/
echo.
goto :eof

:show_help
echo ast-grep Windows Installer
echo Version: 0.40.0 (Improved Edition)
echo.
echo Usage:
echo   install-windows.bat [INSTALL_PATH]
echo   install-windows.bat --help
echo   install-windows.bat --uninstall
echo.
echo Examples:
echo   install-windows.bat
echo   install-windows.bat C:\Tools\ast-grep
echo   install-windows.bat --uninstall
echo.
echo Note: For automatic PATH setup, use PowerShell installer:
echo   powershell -ExecutionPolicy Bypass -File install-windows.ps1 -AddToPath
echo.
goto :eof

:uninstall
echo Uninstalling ast-grep...
echo.

if exist "%INSTALL_PATH%" (
    rd /s /q "%INSTALL_PATH%"
    echo [OK] Removed: %INSTALL_PATH%
) else (
    echo [INFO] Installation directory not found
)

echo.
echo [OK] ast-grep uninstalled
echo.
echo Note: Please remove from PATH manually if you added it
echo.
goto :eof
