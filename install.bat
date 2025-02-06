@echo on
setlocal

:: Define script URL
set SCRIPT_URL=https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/git-cleanbranches.bat
set SCRIPT_NAME=git-cleanbranches.bat

:: Log script start
echo [DEBUG] Starting installation process...

:: Download the script
echo [DEBUG] Downloading %SCRIPT_NAME% from %SCRIPT_URL%
powershell -Command "(New-Object Net.WebClient).DownloadFile('%SCRIPT_URL%', '%SCRIPT_NAME%')"
if exist %SCRIPT_NAME% (
    echo [DEBUG] Download successful.
) else (
    echo [ERROR] Download failed!
    exit /b 1
)

:: Run the script
echo [DEBUG] Executing %SCRIPT_NAME%
start /wait %SCRIPT_NAME%
echo [DEBUG] Execution completed.

:: Clean up (optional)
echo [DEBUG] Deleting %SCRIPT_NAME%
del %SCRIPT_NAME%

:: Log script completion
echo [DEBUG] Installation process completed.

endlocal
