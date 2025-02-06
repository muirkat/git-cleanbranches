# Set the install path (modify as needed)
$installPath = "$env:USERPROFILE\bin\git-cleanbranches.ps1"

# Ensure bin directory exists
New-Item -ItemType Directory -Path "$env:USERPROFILE\bin" -Force | Out-Null

# Download the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/yourrepo/main/git-cleanbranches.ps1" -OutFile $installPath

# Allow execution of the script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

# Make the script runnable from Git Bash or cmd
$env:Path += ";$env:USERPROFILE\bin"

Write-Host "Installation complete! Run with: git cleanbranches"
