@echo off
setlocal enabledelayedexpansion

:: Check if inside a Git repository
if not exist .git (
    echo Error: This is not a Git repository.
    exit /b 1
)

:: Check if Git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Git is not installed.
    exit /b 1
)

:: Ask for email and number of months
set /p YourEmail=Enter Your Email: 
set /p Monthm=Enter the number of months: 

:: Validate number input
for /f "tokens=* delims=0123456789" %%a in ("%Monthm%") do (
    if not "%%a"=="" (
        echo Error: Please enter a valid number of months.
        exit /b 1
    )
)

:: Calculate cutoff date
for /f "delims=" %%i in ('powershell -command "(Get-Date).AddMonths(-%Monthm%).ToString('yyyy-MM-dd')"') do set cutoff_date=%%i

echo.
echo Listing local branches to delete...
for /f "tokens=*" %%B in ('git for-each-ref --format="%%(refname:short) %%(authoremail) %%(authordate:iso)" refs/heads') do (
    for /f "tokens=1,2,3 delims= " %%a in ("%%B") do (
        if "%%b" equ "%YourEmail%" if "%%c" LSS "%cutoff_date%" (
            echo %%a >> local_branches.txt
        )
    )
)

echo.
echo Listing remote branches to delete...
for /f "tokens=*" %%B in ('git for-each-ref --format="%%(refname:short) %%(authoremail) %%(authordate:iso)" refs/remotes') do (
    for /f "tokens=1,2,3 delims= " %%a in ("%%B") do (
        if "%%b" equ "%YourEmail%" if "%%c" LSS "%cutoff_date%" (
            set branch=%%a
            set branch=!branch:origin/=!
            echo !branch! >> remote_branches.txt
        )
    )
)

echo.
if exist local_branches.txt (
    echo The following local branches will be deleted:
    type local_branches.txt
    set /p confirm_local=Do you want to delete these local branches? (y/n): 
    if /i "!confirm_local!" equ "y" (
        for /f %%L in (local_branches.txt) do git branch -D %%L
        echo Local branches deleted.
    ) else (
        echo Skipping local branch deletion.
    )
    del local_branches.txt
) else (
    echo No local branches to delete.
)

echo.
if exist remote_branches.txt (
    echo The following remote branches will be deleted:
    type remote_branches.txt
    set /p confirm_remote=Do you want to delete these remote branches? (y/n): 
    if /i "!confirm_remote!" equ "y" (
        for /f %%R in (remote_branches.txt) do git push origin --delete %%R
        echo Remote branches deleted.
    ) else (
        echo Skipping remote branch deletion.
    )
    del remote_branches.txt
) else (
    echo No remote branches to delete.
)

echo.
echo Operation completed.
endlocal
