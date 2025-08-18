@echo off
SETLOCAL EnableDelayedExpansion

:: --- Configuration ---
SET "MAIN_BRANCH=main"

:: --- Script Logic ---

:: 1. Go to the main branch and make sure it's up to date.
echo [Step 1] Switching to %MAIN_BRANCH% and pulling latest changes...
git checkout %MAIN_BRANCH%
git pull origin %MAIN_BRANCH%

:: 2. Crucial: Fetch all remote branches so we know about the agents' work.
echo [Step 2] Fetching all remote branches and pruning deleted ones...
git fetch origin --prune

:: 3. Loop through REMOTE branches and merge them
echo.
echo [Step 3] Starting merge process for REMOTE branches...
echo ====================================================

:: This is the key change. We list REMOTE branches (`-r`) and filter out the main one.
:: We also filter out "HEAD ->" which can sometimes appear in the list.
FOR /F "tokens=*" %%a IN ('git branch -r ^| findstr /v "HEAD" ^| findstr /v "%MAIN_BRANCH%"') DO (
    :: This inner loop trims leading whitespace from the branch name.
    FOR /F "tokens=*" %%b IN ("%%a") DO (
        echo.
        echo --- Merging remote branch: "%%b" ---
        git merge --no-ff "%%b" -m "Merge branch '%%b'"
        IF !ERRORLEVEL! NEQ 0 (
            echo FAILED to merge "%%b". Please resolve conflicts manually.
            goto :eof
        )
    )
)

:: 4. Push the final result
echo ====================================================
echo All branches merged successfully.
echo [Step 4] Pushing %MAIN_BRANCH% to origin...
git push origin %MAIN_BRANCH%

echo.
echo Done!

:eof
ENDLOCAL