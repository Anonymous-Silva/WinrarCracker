@echo off
title RAR Password Cracker
echo Verifying unrar.exe...
IF EXIST "C:\Program Files\WinRAR\unrar.exe" (
    set UNRAR="C:\Program Files\WinRAR\unrar.exe"
) ELSE (
    echo Error: unrar.exe not found in "C:\Program Files\WinRAR\". Install WinRAR or place unrar.exe in script directory.
    pause
    exit
)

:INPUT
cls
echo.
echo Drag and drop your RAR file here or paste the full path (e.g., C:\Users\YourName\Desktop\file.rar):
set /p RAR_PATH=Path: 
IF "%RAR_PATH%"=="" (
    echo You can't leave this blank.
    pause
    goto INPUT
)

:: Remove quotes if present (drag-and-drop adds them)
set RAR_PATH=%RAR_PATH:"=%

:: Check if file exists
IF NOT EXIST "%RAR_PATH%" (
    echo File not found: %RAR_PATH%
    pause
    goto INPUT
)

:: Create temp folder for extraction
set TMP=TempExtract_%RANDOM%
mkdir "%TMP%"

echo.
echo Starting password cracking for %RAR_PATH%...
echo Trying numeric passwords...
set /a PASS=0

:TRY_PASSWORD
set /a PASS+=1
echo Trying password: %PASS%
%UNRAR% e -p%PASS% "%RAR_PATH%" "%TMP%" >nul 2>&1
if %errorlevel%==0 (
    echo.
    echo Success! Password found: %PASS%
    rmdir /s /q "%TMP%"
    pause
    exit
)
:: Limit to avoid infinite loop; adjust as needed
if %PASS% GEQ 10000 (
    echo Password not found in range 0-9999. Try a different range or method.
    rmdir /s /q "%TMP%"
    pause
    exit
)
goto TRY_PASSWORD