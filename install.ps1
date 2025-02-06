$scriptName = "git-cleanbranches.ps1"
$scriptUrl = "https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/$scriptName"
$scriptDestination = "$env:USERPROFILE\Scripts"
$profileFile = $PROFILE

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

# Add the git-cleanbranches function to the PowerShell profile if not already present
$functionCode = @"
Function git-cleanbranches {
    & "$scriptDestination\$scriptName" @args
}
"@

# Check if the function is already in the profile
if (-not (Select-String -Pattern "Function git-cleanbranches" -Path $profileFile)) {
    Write-Host "Adding git-cleanbranches function to PowerShell profile..." -ForegroundColor Cyan
    Add-Content -Path $profileFile -Value $functionCode
} else {
    Write-Host "git-cleanbranches function already exists in profile" -ForegroundColor Green
}

# Reload the profile to apply changes
Write-Host "Reloading PowerShell profile..." -ForegroundColor Cyan
. $PROFILE

Write-Host "Installation complete! You can now run 'git cleanbranches' from any PowerShell window." -ForegroundColor Green
