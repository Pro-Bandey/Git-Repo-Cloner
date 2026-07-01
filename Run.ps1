# Change active directory to the location of this script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($ScriptDir) { Set-Location $ScriptDir }

# Check if Python is installed
$PythonInstalled = $null -ne (Get-Command python -ErrorAction SilentlyContinue) -or $null -ne (Get-Command py -ErrorAction SilentlyContinue)

# Check if Git is installed
$GitInstalled = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

# CASE 1: Both installed
if ($PythonInstalled -and $GitInstalled) {
    if (Get-Command py -ErrorAction SilentlyContinue) {
        py GitRepoCloner.py
    } else {
        python GitRepoCloner.py
    }
}
# CASE 2: Both missing
elseif (-not $PythonInstalled -and -not $GitInstalled) {
    Write-Host "❌ Python and Git are not installed." -ForegroundColor Red
    $choice = Read-Host "Would you like to install both? (y/n)"
    if ($choice.ToLower() -eq 'y') {
        Write-Host "Installing Python and Git..." -ForegroundColor Cyan
        winget install Python.Python.3 --silent
        winget install Git.Git --silent
        Write-Host "Please restart your terminal or computer so the new paths are recognized." -ForegroundColor Yellow
    }
}
# CASE 3: Python missing
elseif (-not $PythonInstalled) {
    Write-Host "❌ Python is not installed." -ForegroundColor Red
    $choice = Read-Host "Would you like to install Python? (y/n)"
    if ($choice.ToLower() -eq 'y') {
        Write-Host "Installing Python..." -ForegroundColor Cyan
        winget install Python.Python.3 --silent
        Write-Host "Please restart your terminal or computer so Python is recognized." -ForegroundColor Yellow
    }
}
# CASE 4: Git missing
elseif (-not $GitInstalled) {
    Write-Host "❌ Git is not installed." -ForegroundColor Red
    $choice = Read-Host "Would you like to install Git? (y/n)"
    if ($choice.ToLower() -eq 'y') {
        Write-Host "Installing Git..." -ForegroundColor Cyan
        winget install Git.Git --silent
        Write-Host "Please restart your terminal or computer so Git is recognized." -ForegroundColor Yellow
    }
}

Read-Host "Press Enter to exit"