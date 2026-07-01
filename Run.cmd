@echo off
setlocal enabledelayedexpansion

:: Check if Python is installed
set "PYTHON_INSTALLED=1"
where python >nul 2>nul
if %errorlevel% neq 0 (
    where py >nul 2>nul
    if %errorlevel% neq 0 (
        set "PYTHON_INSTALLED=0"
    )
)

:: Check if Git is installed
set "GIT_INSTALLED=1"
where git >nul 2>nul
if %errorlevel% neq 0 (
    set "GIT_INSTALLED=0"
)

:: If both are installed, run the script immediately
if %PYTHON_INSTALLED%==1 if %GIT_INSTALLED%==1 (
    goto :RUN_SCRIPT
)

:: CASE 1: Both missing
if %PYTHON_INSTALLED%==0 if %GIT_INSTALLED%==0 (
    echo ❌ Python and Git are not installed.
    set /p install="Would you like to install both now? (y/n): "
    if /i "!install!"=="y" (
        echo Installing Python and Git...
        winget install Python.Python.3 --silent
        winget install Git.Git --silent
        echo.
        echo Please restart your terminal or computer so the new paths are recognized.
        pause
        exit /b
    ) else (
        echo Cannot run script without Python and Git.
        pause
        exit /b
    )
)

:: CASE 2: Python missing
if %PYTHON_INSTALLED%==0 (
    echo ❌ Python is not installed.
    set /p install="Would you like to install Python now? (y/n): "
    if /i "!install!"=="y" (
        echo Installing Python...
        winget install Python.Python.3 --silent
        echo.
        echo Please restart your terminal or computer so Python is recognized.
        pause
        exit /b
    ) else (
        echo Cannot run script without Python.
        pause
        exit /b
    )
)

:: CASE 3: Git missing
if %GIT_INSTALLED%==0 (
    echo ❌ Git is not installed.
    set /p install="Would you like to install Git now? (y/n): "
    if /i "!install!"=="y" (
        echo Installing Git...
        winget install Git.Git --silent
        echo.
        echo Please restart your terminal or computer so Git is recognized.
        pause
        exit /b
    ) else (
        echo Cannot run script without Git.
        pause
        exit /b
    )
)

:RUN_SCRIPT
:: Run Python using the available command
where py >nul 2>nul
if %errorlevel%==0 (
    py GitRepoCloner.py
) else (
    python GitRepoCloner.py
)
pause