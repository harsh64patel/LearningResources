@echo off
setlocal EnableDelayedExpansion

set PATTERN=%1
set OUTPUT=.\.continue\ai_context.txt

if "%PATTERN%"=="" (
    echo Usage: get_ai_context.bat [pattern]
    echo Example: get_ai_context.bat customer
    exit /b 1
)

echo Building context for pattern: "%PATTERN%"
echo.

> "%OUTPUT%" (
    for /f "usebackq delims=" %%f in (`git ls-files ^| findstr /v ".tst/" ^| findstr /v "migrations/" ^| findstr /v "fixtures/" ^| findstr /v ".min.js" ^| findstr /v "*.cgr"^| findstr /v "*.3dxml"^| findstr /v ".CATPart" ^| findstr /v ".lock" ^| findstr /v ".png" ^| findstr /i "%PATTERN%"`) do (
        set FPATH=%%f
        set FPATH=!FPATH:/=\!
        echo --- FILE: %%f ---
        type "!FPATH!"
        echo.
    )
)

echo.

echo Done! Copied to %OUTPUT%.