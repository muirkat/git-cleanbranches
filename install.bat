@echo off
setlocal

:: Define script URL
set SCRIPT_URL=https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/git-cleanbranches.bat
set SCRIPT_NAME=git-cleanbranches.bat

:: Download the script
powershell -Command "(New-Object Net.WebClient).DownloadFile('%SCRIPT_URL%', '%SCRIPT_NAME%')"

:: Run the script
start /wait %SCRIPT_NAME%

:: Clean up (optional)
del %SCRIPT_NAME%

endlocal
