@echo on
setlocal

:: Define script URL
set SCRIPT_URL=https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/git-cleanbranches.bat
set SCRIPT_NAME=git-cleanbranches.bat
set INSTALL_DIR=%USERPROFILE%\bin
set COMMAND_NAME=git-cleanbranches

:: Log script start
echo [DEBUG] Starting installation process...

:: Ensure install directory exists
if not exist "%INSTALL_DIR%" (
    echo [DEBUG] Creating install directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

:: Download the script
echo [DEBUG] Downloading %SCRIPT_NAME% from %SCRIPT_URL% to %INSTALL_DIR%
powershell -Command "(New-Object Net.WebClient).DownloadFile('%SCRIPT_URL%', '%INSTALL_DIR%\%SCRIPT_NAME%')"
if exist "%INSTALL_DIR%\%SCRIPT_NAME%" (
    echo [DEBUG] Download successful.
) else (
    echo [ERROR] Download failed!
    exit /b 1
)

:: Ensure the script is executable
echo [DEBUG] Making %SCRIPT_NAME% executable
attrib +x "%INSTALL_DIR%\%SCRIPT_NAME%"

:: Make script globally accessible
echo [DEBUG] Adding %INSTALL_DIR% to PATH if not already present...
echo %PATH% | findstr /I /C:"%INSTALL_DIR%" >nul || (
    setx PATH "%INSTALL_DIR%" /M
    echo [DEBUG] PATH updated. You may need to restart your terminal.
)

:: Confirm installation
echo [DEBUG] Installation complete. You can now run 'git cleanbranches' from any command prompt.

echo [DEBUG] Testing installation...
where git-cleanbranches && echo [SUCCESS] 'git cleanbranches' is now available.

echo [DEBUG] Finished.
endlocal
