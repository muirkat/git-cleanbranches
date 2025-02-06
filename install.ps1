$scriptName = "git-cleanbranches.ps1"
$scriptSource = "$PSScriptRoot\$scriptName"
$scriptDestination = "$env:USERPROFILE\Scripts"

# Ensure the destination folder exists
if (!(Test-Path $scriptDestination)) {
    New-Item -ItemType Directory -Path $scriptDestination | Out-Null
}

# Copy the script to the destination
Write-Host "Copying script to $scriptDestination..." -ForegroundColor Cyan
Copy-Item -Path $scriptSource -Destination "$scriptDestination\$scriptName" -Force

# Add the folder to PATH if not already added
$envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
if ($envPath -notlike "*$scriptDestination*") {
    Write-Host "Adding $scriptDestination to system PATH..." -ForegroundColor Cyan
    [System.Environment]::SetEnvironmentVariable("Path", $envPath + ";$scriptDestination", [System.EnvironmentVariableTarget]::User)
} else {
    Write-Host "PATH already includes $scriptDestination" -ForegroundColor Green
}

# Allow PowerShell scripts to run
Write-Host "Setting PowerShell execution policy..." -ForegroundColor Cyan
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

Write-Host "Installation complete! You can now run 'git cleanbranches' from any PowerShell window." -ForegroundColor Green
