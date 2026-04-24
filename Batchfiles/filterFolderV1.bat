@echo off
setlocal EnableDelayedExpansion

:: ============================================================
:: CONFIGURATION
:: ============================================================

set OUTPUT=.\.continue\ai_context.txt
set TMP_FILE=%TEMP%\repo_files_%RANDOM%.txt

:: Optional scope argument
set SCOPE=%1

:: Excluded folders
set EXCL_DIR=.tst/ migrations/ fixtures/ static/ assets/ dist/ build/

:: Excluded extensions
set EXCL_EXT=.min.js .lock .png .jpg .jpeg .svg .gif .ico .map .pyc .pdf .woff .woff2

echo.
echo [api_context] Collecting source files...
if not "%SCOPE%"=="" echo [api_context] Scoped to: *%SCOPE%*
echo Output: %OUTPUT%
echo.

:: ============================================================
:: HEADER
:: ============================================================

> "%OUTPUT%" (
echo === REPOSITORY: %CD%
echo === GENERATED:  %DATE% %TIME%
if not "%SCOPE%"=="" echo === SCOPE: %SCOPE%
echo.
)

:: ============================================================
:: BUILD FILTER PIPELINE
:: ============================================================

set FILTER=git ls-files

for %%d in (%EXCL_DIR%) do (
    set FILTER=!FILTER! ^| findstr /v "%%d"
)

for %%e in (%EXCL_EXT%) do (
    set FILTER=!FILTER! ^| findstr /v "%%e"
)

if not "%SCOPE%"=="" (
    set FILTER=!FILTER! ^| findstr /i "%SCOPE%"
)

set FILTER=!FILTER! ^| findstr /v /i "test spec __test__ .test. .spec."

:: ============================================================
:: RUN FILTER ONCE
:: ============================================================

cmd /c "!FILTER!" > "%TMP_FILE%"

for /f %%c in ('find /c /v "" ^< "%TMP_FILE%"') do set FILE_COUNT=%%c

echo [api_context] Found %FILE_COUNT% source files

:: ============================================================
:: FILE LIST
:: ============================================================

echo === ALL SOURCE FILES === >> "%OUTPUT%"
type "%TMP_FILE%" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ============================================================
:: FILE CONTENTS
:: ============================================================

echo === FILE CONTENTS === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

set CONTENT_COUNT=0

for /f "usebackq delims=" %%f in ("%TMP_FILE%") do (

    set FPATH=%%f
    set FPATH=!FPATH:/=\!

    echo ======================================== >> "%OUTPUT%"
    echo FILE: %%f >> "%OUTPUT%"
    echo ======================================== >> "%OUTPUT%"

    type "!FPATH!" >> "%OUTPUT%"
    echo. >> "%OUTPUT%"
    echo. >> "%OUTPUT%"

    set /a CONTENT_COUNT+=1
)

:: ============================================================
:: DEPENDENCIES
:: ============================================================

echo === DEPENDENCIES === >> "%OUTPUT%"

if exist "package.json" (
echo --- package.json --- >> "%OUTPUT%"
type package.json >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

if exist "requirements.txt" (
echo --- requirements.txt --- >> "%OUTPUT%"
type requirements.txt >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

if exist "pyproject.toml" (
echo --- pyproject.toml --- >> "%OUTPUT%"
type pyproject.toml >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

:: ============================================================
:: CLEANUP
:: ============================================================

del "%TMP_FILE%" >nul 2>nul

echo.
echo [api_context] Done!
echo   Files collected : %CONTENT_COUNT%
echo   Output file     : %OUTPUT%
echo.
echo Next step in Continue.dev:
echo   @File .continue/api_context.txt
echo   [paste the API Reference Prompt]
echo.