Linux/macOS\
```curl -fsSL https://raw.githubusercontent.com/muirkat/git-cleanbranches/refs/heads/main/install.sh | sudo bash```

Windows Powershell\
```$installUrl = "https://raw.githubusercontent.com/your-username/your-repo/main/install.ps1" ```
```Invoke-WebRequest -Uri $installUrl -OutFile "$env:TEMP\install.ps1"; & "$env:TEMP\install.ps1"```
