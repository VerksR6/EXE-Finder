@echo off
setlocal enabledelayedexpansion
title Verk's EXE Finder
mode con cols=90 lines=30

:menu
cls
:: Start in Purple
color 0D
echo ==========================================================
echo                WELCOME TO VERK'S EXE FINDER               
echo ==========================================================
echo.
echo  [1] To Proceed
echo  [2] To Close
echo.
echo ==========================================================
set /p choice="Selection: "

if "%choice%"=="2" exit
if "%choice%"=="1" goto start_scan
goto menu

:start_scan
:: Switch to White
color 0F
cls
echo ==========================================================
echo            SCANNING FOR GAMES AND USER APPS...
echo ==========================================================
echo.
echo  Searching Desktop, Downloads, and Game Folders...
echo  Please wait while Verk's Finder works...
echo.

set "results=%temp%\VerkResults.txt"
echo VERK'S EXE FINDER - FOUND EXECUTABLES > "%results%"
echo ---------------------------------------------------------- >> "%results%"

:: This scans the 3 most common places games and apps are installed
:: 1. Your User Profile (Roblox/Minecraft/Downloads)
:: 2. Program Files (Steam/Epic Games)
:: 3. Program Files x86 (Older Games)

for %%p in ("%UserProfile%" "%ProgramFiles%" "%ProgramFiles(x86)%") do (
    echo  Scanning: %%p...
    :: We use /a-h to skip hidden system files and avoid the "Hardware" junk
    for /f "delims=" %%f in ('dir /s /b /a-h "%%~p\*.exe" 2^>nul') do (
        echo %%f | findstr /i /v "Windows Microsoft Drivers System32 Temp .NET Framework" >nul
        if !errorlevel! == 0 (
            echo [EXE] %%~nxf >> "%results%"
            echo PATH: %%~dpf >> "%results%"
            echo ---------------------------------------------------------- >> "%results%"
        )
    )
)

:: Check if we actually found anything
findstr /c:"[EXE]" "%results%" >nul
if %errorlevel% neq 0 (
    echo. >> "%results%"
    echo NO USER EXES FOUND. TRY RUNNING AS ADMIN. >> "%results%"
)

start notepad.exe "%results%"
echo.
echo  Done! If the file is still empty, right-click the .bat 
echo  and select "Run as Administrator".
pause
goto menu