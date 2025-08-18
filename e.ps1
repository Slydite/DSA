# --- Configuration ---
$mainBranch = "main"

# --- Script Logic ---

# Stop the script if any command fails
$ErrorActionPreference = "Stop"

# 1. Get to a clean state on the main branch
Write-Host "Switching to '$mainBranch' branch..." -ForegroundColor Green
git checkout $mainBranch

Write-Host "Pulling latest changes for '$mainBranch'..." -ForegroundColor Green
git pull origin $mainBranch

# 2. Fetch all remote branches to ensure our local list is up-to-date
Write-Host "Fetching all remote branches..." -ForegroundColor Cyan
git fetch --prune

# 3. Get a list of all local branches, excluding the main branch
Write-Host "Finding all feature branches to merge..."
$branchesToMerge = git branch | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "* $mainBranch" -and $_ -ne $mainBranch }

if ($branchesToMerge.Length -eq 0) {
    Write-Host "No other branches found to merge." -ForegroundColor Yellow
    exit
}

Write-Host "Found the following branches to merge:" -ForegroundColor Cyan
$branchesToMerge

# 4. Loop through each branch and merge it
foreach ($branch in $branchesToMerge) {
    Write-Host "----------------------------------------------------"
    Write-Host "Merging branch '$branch' into '$mainBranch'..." -ForegroundColor Green

    # Use --no-ff to create a merge commit, preserving history
    git merge --no-ff $branch -m "Merge branch '$branch'"
}

# 5. Push the final result to the remote repository
Write-Host "----------------------------------------------------"
Write-Host "All branches merged. Pushing '$mainBranch' to origin..." -ForegroundColor Green
git push origin $mainBranch

Write-Host "Done!" -ForegroundColor Magenta