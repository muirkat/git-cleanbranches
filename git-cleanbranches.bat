@echo off
setlocal enabledelayedexpansion

:: Ensure the script runs inside a Git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: This is not a Git repository.
    exit /b 1
)

:: Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed.
    exit /b 1
)

:: Ask for the email and months
set /p YourEmail=Enter Your Email: 
set /p Monthm=Enter the number of months: 

:: Validate number input
for /f "tokens=1" %%a in ("%Monthm%") do (
    set "valid=%%a"
)
if not "!valid!"=="" if not "!valid!"=="%Monthm%" (
    echo Error: Please enter a valid number of months.
    exit /b 1
)

:: Calculate the cutoff date
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set datetime=%%a
set year=!datetime:~0,4!
set month=!datetime:~4,2!
set day=!datetime:~6,2!
set /a cutoff_month=%month% - %Monthm%

:: List local branches to delete
echo Listing local branches to delete...
for /f "delims=" %%b in ('git for-each-ref --format="%%(refname:short) %%(authoremail) %%(authordate:iso)" refs/heads') do (
    set branch_info=%%b
    for /f "tokens=1,2,3" %%c in ("!branch_info!") do (
        set branch=%%c
        set email=%%d
        set date=%%e
        if !date! lss !cutoff_date! if "!email!"=="%YourEmail%" if not "!branch!"=="master" if not "!branch!"=="development" if not "!branch!"=="staging" (
            echo !branch!
        )
    )
)

:: List remote branches to delete
echo Listing remote branches to delete...
for /f "delims=" %%b in ('git for-each-ref --format="%%(refname:short) %%(authoremail) %%(authordate:iso)" refs/remotes') do (
    set branch_info=%%b
    for /f "tokens=1,2,3" %%c in ("!branch_info!") do (
        set branch=%%c
        set email=%%d
        set date=%%e
        if !date! lss !cutoff_date! if "!email!"=="%YourEmail%" if not "!branch!"=="origin/master" if not "!branch!"=="origin/development" if not "!branch!"=="origin/staging" (
            echo !branch!
        )
    )
)

:: Confirm and delete local branches
set /p confirm_local=Do you want to delete these local branches? (y/n): 
if /i "%confirm_local%"=="y" (
    echo Deleting local branches...
    :: Loop through and delete each branch
    :: (Add code to delete branches here)
)

:: Confirm and delete remote branches
set /p confirm_remote=Do you want to delete these remote branches? (y/n): 
if /i "%confirm_remote%"=="y" (
    echo Deleting remote branches...
    :: Loop through and delete each remote branch
    :: (Add code to delete remote branches here)
)

echo Operation completed.
endlocal
