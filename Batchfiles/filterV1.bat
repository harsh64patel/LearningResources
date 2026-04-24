@echo off
setlocal EnableDelayedExpansion

set PATTERN=%1

if "%PATTERN%"=="" (
    echo Usage: get_ai_context.bat [pattern]
    echo Example: get_ai_context.bat customer
    exit /b 1
)

echo Building context for pattern: "%PATTERN%"
echo.

:: --- Repo structure ---
echo === REPO STRUCTURE === > ai_context.txt

git ls-files ^
  | findstr /v ".tst/" ^
  | findstr /v "migrations/" ^
  | findstr /v "fixtures/" ^
  | findstr /v "static/" ^
  | findstr /v "assets/" ^
  | findstr /v ".min.js" ^
  | findstr /v ".lock" ^
  | findstr /v ".png" ^
  | findstr /v ".jpg" ^
  | findstr /v ".svg" ^
  >> ai_context.txt

echo. >> ai_context.txt

:: --- Matching file contents ---
echo === FILES MATCHING: %PATTERN% === >> ai_context.txt
echo. >> ai_context.txt

for /f "usebackq delims=" %%f in (`git ls-files ^| findstr /v ".tst/" ^| findstr /v "migrations/" ^| findstr /v "fixtures/" ^| findstr /v ".min.js" ^| findstr /v ".lock" ^| findstr /v ".png" ^| findstr /i "%PATTERN%"`) do (

    :: Convert forward slashes to backslashes
    set FPATH=%%f
    set FPATH=!FPATH:/=\!

    echo --- FILE: %%f --- >> ai_context.txt
    type "!FPATH!" >> ai_context.txt
    echo. >> ai_context.txt
)

:: --- Copy to clipboard ---
clip < ai_context.txt

echo Done! Copied to clipboard. Also saved to ai_context.txt