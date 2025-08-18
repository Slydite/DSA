@echo off
SETLOCAL

:: --- Configuration ---
SET MAIN_BRANCH=main

:: --- Script Logic ---

:: 1. Get to a clean state on the main branch
echo Switching to %MAIN_BRANCH% and pulling latest changes...
git checkout %MAIN_BRANCH%
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to checkout %MAIN_BRANCH%. Aborting.
    goto :eof
)
git pull origin %MAIN_BRANCH%

:: 2. Fetch remote branches
echo Fetching remote branches...
git fetch --prune

:: 3. Loop through branches and merge them
echo.
echo Starting merge process...
echo ====================================================

FOR /F "tokens=*" %%b IN ('git branch') DO (
    SET branch_name=%%b
    
    :: The CMD shell variable expansion is a bit tricky, so we enable delayed expansion
    SETLOCAL EnableDelayedExpansion
    
    :: Clean up the branch name (remove the * and trim spaces)
    SET cleaned_name=!branch_name:* =!
    
    IF NOT "!cleaned_name!" == "%MAIN_BRANCH%" (
        echo.
        echo Merging branch: !cleaned_name!
        git merge --no-ff "!cleaned_name!" -m "Merge branch '!cleaned_name!'"
        IF !ERRORLEVEL! NEQ 0 (
            echo FAILED to merge !cleaned_name!. Please resolve conflicts manually.
            goto :eof
        )
    )
    ENDLOCAL
)

:: 4. Push the final result
echo ====================================================
echo All branches merged successfully.
echo Pushing %MAIN_BRANCH% to origin...
git push origin %MAIN_BRANCH%

echo.
echo Done!

ENDLOCAL
:eof