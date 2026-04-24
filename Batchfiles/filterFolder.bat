@echo off
setlocal EnableDelayedExpansion

set OUTPUT=.\.continue\ai_context.txt
set TMP_FILE=.\.continue\temp.txt
set SCOPE=%1
set IGNORE1=%2
set IGNORE2=%3

echo.
echo [api_context] Building AI codebase map...
echo Output: %OUTPUT%
echo.

> "%OUTPUT%" (
echo === REPOSITORY: %CD%
echo === GENERATED: %DATE% %TIME%
if not "%SCOPE%"=="" echo === SCOPE: %SCOPE%
echo.
echo PROJECT STRUCTURE
echo.
)

:: ----------------------------------------------------
:: STEP 1: Get repo files (code files only)
:: ----------------------------------------------------

> "%TMP_FILE%" (
git ls-files "*.js"
git ls-files "*.ts"
git ls-files "*.tsx"
git ls-files "*.py"
git ls-files "*.java"
git ls-files "*.go"
git ls-files "*.cpp"
git ls-files "*.c"
git ls-files "*.h"
git ls-files "*.hpp"
git ls-files "*.cs"
)

:: Apply SCOPE filter
if not "%SCOPE%"=="" (
    findstr /I "%SCOPE%" "%TMP_FILE%" > "%TMP_FILE%.scope"
    move /y "%TMP_FILE%.scope" "%TMP_FILE%" >nul
)

:: Exclude files containing IGNORE1
if not "%IGNORE1%"=="" (
    findstr /V /I "%IGNORE1%" "%TMP_FILE%" > "%TMP_FILE%.clean"
    move /y "%TMP_FILE%.clean" "%TMP_FILE%" >nul
)

:: Exclude files containing IGNORE2
if not "%IGNORE2%"=="" (
    findstr /V /I "%IGNORE2%" "%TMP_FILE%" > "%TMP_FILE%.clean"
    move /y "%TMP_FILE%.clean" "%TMP_FILE%" >nul
)

:: ----------------------------------------------------
:: STEP 2: Build compact codebase map (detect all functions)
:: ----------------------------------------------------

for /f "usebackq delims=" %%f in ("%TMP_FILE%") do (

    set FILE=%%f
    set FILE=!FILE:/=\!

    echo %%f >> "%OUTPUT%"

    echo   functions: >> "%OUTPUT%"
    findstr /N /R ^
     /C:"function " ^
     /C:"const " ^
     /C:"async " ^
     /C:"=>" ^
     /C:"def " ^
     "!FILE!" >> "%OUTPUT%" 2>nul

    echo   classes: >> "%OUTPUT%"
    findstr /N /R ^
     /C:"class " ^
     "!FILE!" >> "%OUTPUT%" 2>nul

    echo   module_exports: >> "%OUTPUT%"
    findstr /N /R ^
     /C:"module.exports" ^
     /C:"exports." ^
     "!FILE!" >> "%OUTPUT%" 2>nul

    echo   routes: >> "%OUTPUT%"
    findstr /N /R ^
     /C:"router." ^
     /C:"app.get" ^
     /C:"app.post" ^
     /C:"app.put" ^
     /C:"app.delete" ^
     "!FILE!" >> "%OUTPUT%" 2>nul
	 
	 echo   imports: >> "%OUTPUT%"
	findstr /N /R /C:"import " /C:"require(" "!FILE!" >> "%OUTPUT%" 2>nul

    echo. >> "%OUTPUT%"
)

:: ----------------------------------------------------
:: STEP 3: Important config files
:: ----------------------------------------------------

echo === DEPENDENCIES === >> "%OUTPUT%"

if exist package.json (
echo --- package.json --- >> "%OUTPUT%"
type package.json >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

if exist requirements.txt (
echo --- requirements.txt --- >> "%OUTPUT%"
type requirements.txt >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

if exist pyproject.toml (
echo --- pyproject.toml --- >> "%OUTPUT%"
type pyproject.toml >> "%OUTPUT%"
echo. >> "%OUTPUT%"
)

del "%TMP_FILE%" >nul 2>nul

echo.
echo [api_context] Done!
echo Output: %OUTPUT%
echo.
echo Use in Continue:
echo @File .continue/ai_context.txt
echo.