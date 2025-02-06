$scriptName = "git-cleanbranches.ps1"
$scriptUrl = "https://raw.githubusercontent.com/your-username/your-repo/main/$scriptName"
$scriptDestination = "$env:USERPROFILE\Scripts"

# Ensure the destination folder exists
if (!(Test-Path $scriptDestination)) {
    New-Item -ItemType Directory -Path $scriptDestination -Force | Out-Null
}

# Download the script from GitHub
Write-Host "Downloading $scriptName from GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $scriptUrl -OutFile "$scriptDestination\$scriptName"

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
