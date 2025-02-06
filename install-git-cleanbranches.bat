@echo off
setlocal

:: Define script URL and other variables
set SCRIPT_URL=https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/git-cleanbranches.bat
set SCRIPT_NAME=git-cleanbranches.bat
set INSTALL_DIR=%USERPROFILE%\bin
set COMMAND_NAME=git-cleanbranches

:: Ensure install directory exists
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Download the script
powershell -Command "(New-Object Net.WebClient).DownloadFile('%SCRIPT_URL%', '%INSTALL_DIR%\%SCRIPT_NAME%')"
if exist "%INSTALL_DIR%\%SCRIPT_NAME%" (
    :: Download successful
    echo [INFO] Script downloaded successfully to "%INSTALL_DIR%\%SCRIPT_NAME%"
) else (
    echo [ERROR] Download failed!
    exit /b 1
)

:: Ensure the script is executable
attrib +x "%INSTALL_DIR%\%SCRIPT_NAME%"

:: Make script globally accessible by adding its directory to the PATH if not already added
echo %PATH% | findstr /I /C:"%INSTALL_DIR%" >nul || (
    setx PATH "%INSTALL_DIR%;%PATH%" /M
    echo [INFO] Added "%INSTALL_DIR%" to PATH
)

:: Confirm installation
echo Installation complete. You can now run '%COMMAND_NAME%' from any command prompt.

:: Test the installation
where %COMMAND_NAME% && echo [SUCCESS] '%COMMAND_NAME%' is now available.

endlocal
