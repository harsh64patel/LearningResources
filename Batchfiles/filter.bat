@echo off
setlocal EnableDelayedExpansion

set PATTERN=%1
set OUTPUT=.\.continue\ai_context.txt

if "%PATTERN%"=="" (
    echo Usage: get_ai_context.bat [pattern]
    echo Example: get_ai_context.bat customer
    exit /b 1
)

echo === FILES MATCHING: %PATTERN% ===
echo.

git ls-files ^
  | findstr /v ".tst/" ^
  | findstr /v "migrations/" ^
  | findstr /v "fixtures/" ^
  | findstr /v ".min.js" ^
  | findstr /v ".lock" ^
  | findstr /v ".png" ^
  | findstr /i "%PATTERN%" ^
    > "%OUTPUT%"

echo Done! Saved to %OUTPUT% .