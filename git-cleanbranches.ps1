# Ensure the script runs inside a Git repository
if (-not (Test-Path .git)) {
    Write-Host "Error: This is not a Git repository." -ForegroundColor Red
    exit 1
}

# Check if Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Git is not installed." -ForegroundColor Red
    exit 1
}

# Ask for the email and number of months
$YourEmail = Read-Host "Enter Your Email"
$Monthm = Read-Host "Enter the number of months"

# Validate number input
if ($Monthm -match "^\d+$") {
    # Calculate cutoff date
    $cutoff_date = (Get-Date).AddMonths(-[int]$Monthm).ToString("yyyy-MM-dd")
} else {
    Write-Host "Error: Please enter a valid number of months." -ForegroundColor Red
    exit 1
}

# List local branches to delete
Write-Host "`nListing local branches to delete..."
$local_branches = git for-each-ref --format='%(refname:short) %(authoremail) %(authordate:iso)' refs/heads |
    ForEach-Object {
        $branch, $email, $date = $_ -split " "
        if ($date -lt $cutoff_date -and $email -match $YourEmail -and $branch -notmatch "^(master|development|staging)$") {
            $branch
        }
    }

# List remote branches to delete
Write-Host "`nListing remote branches to delete..."
$remote_branches = git for-each-ref --format='%(refname:short) %(authoremail) %(authordate:iso)' refs/remotes |
    ForEach-Object {
        $branch, $email, $date = $_ -split " "
        if ($date -lt $cutoff_date -and $email -match $YourEmail -and $branch -notmatch "^(origin/master|origin/development|origin/staging)$") {
            $branch -replace "^origin/", ""
        }
    }

# Confirm and delete local branches
if ($local_branches.Count -gt 0) {
    Write-Host "`nThe following local branches will be deleted:" -ForegroundColor Yellow
    $local_branches | ForEach-Object { Write-Host $_ }
    $confirm_local = Read-Host "Do you want to delete these local branches? (y/n)"
    if ($confirm_local -match "^[Yy]$") {
        Write-Host "Deleting local branches..." -ForegroundColor Green
        $local_branches | ForEach-Object { git branch -D $_ }
        Write-Host "Local branches deleted."
    } else {
        Write-Host "Skipping local branch deletion."
    }
} else {
    Write-Host "No local branches to delete."
}

# Confirm and delete remote branches
if ($remote_branches.Count -gt 0) {
    Write-Host "`nThe following remote branches will be deleted:" -ForegroundColor Yellow
    $remote_branches | ForEach-Object { Write-Host $_ }
    $confirm_remote = Read-Host "Do you want to delete these remote branches? (y/n)"
    if ($confirm_remote -match "^[Yy]$") {
        Write-Host "Deleting remote branches..." -ForegroundColor Green
        $remote_branches | ForEach-Object { git push origin --delete $_ }
        Write-Host "Remote branches deleted."
    } else {
        Write-Host "Skipping remote branch deletion."
    }
} else {
    Write-Host "No remote branches to delete."
}

Write-Host "`nOperation completed." -ForegroundColor Cyan
