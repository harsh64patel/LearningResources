@echo off
setlocal EnableDelayedExpansion

set OUTPUT=.\.continue\ai_context.txt
set TMP_FILE=%TEMP%\repo_files_%RANDOM%.txt
set SCOPE=%1

echo.
echo [api_context] Building function index...
echo Output: %OUTPUT%
echo.

:: header
> "%OUTPUT%" (
echo === REPOSITORY: %CD%
echo === GENERATED: %DATE% %TIME%
if not "%SCOPE%"=="" echo === SCOPE: %SCOPE%
echo.
)

:: get repo files
git ls-files > "%TMP_FILE%"
findstr /I /C:".js" /C:".ts" /C:".jsx" /C:".tsx" /C:".py" /C:".java" /C:".go" /C:".php" /C:".cs" /C:".cpp" "%TMP_FILE%" > "%TMP_FILE%.code"
move /y "%TMP_FILE%.code" "%TMP_FILE%" >nul

:: optional scope
if not "%SCOPE%"=="" (
    findstr /i "%SCOPE%" "%TMP_FILE%" > "%TMP_FILE%.scoped"
    move /y "%TMP_FILE%.scoped" "%TMP_FILE%" >nul
)

echo === FILE INDEX === >> "%OUTPUT%"
type "%TMP_FILE%" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo === FUNCTION SIGNATURES === >> "%OUTPUT%"
echo. >> "%OUTPUT%"

for /f "usebackq delims=" %%f in ("%TMP_FILE%") do (

    set FILE=%%f
    set FILE=!FILE:/=\!

    echo --- %%f --- >> "%OUTPUT%"

    :: JS / TS / Python / Java style functions
    findstr /R /C:"function " /C:"def " /C:"class " /C:"async " "!FILE!" >> "%OUTPUT%" 2>nul

    :: arrow functions
    findstr /R /C:"=>" "!FILE!" >> "%OUTPUT%" 2>nul

    :: API routes
    findstr /R /C:"router." /C:"app.get" /C:"app.post" /C:"app.put" /C:"app.delete" "!FILE!" >> "%OUTPUT%" 2>nul

    echo. >> "%OUTPUT%"
)

echo.
echo [api_context] Done!
echo Output file: %OUTPUT%
echo.
echo Use in Continue:
echo @File .continue/ai_context.txt
echo.