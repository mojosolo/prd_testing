@echo off
:: This script helps run the application on Windows systems
:: It tries to find Python on the system and run the main script

echo Trying to find Python on your system...

:: Try different ways to run Python
set PYTHON_CMD=

:: Try python
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Found Python using 'python' command
    set PYTHON_CMD=python
    goto :RUN_SCRIPT
)

:: Try py (Python launcher)
py --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Found Python using 'py' command
    set PYTHON_CMD=py
    goto :RUN_SCRIPT
)

:: Try python3
python3 --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Found Python using 'python3' command
    set PYTHON_CMD=python3
    goto :RUN_SCRIPT
)

:: Check common installation locations
set PYTHON_LOCATIONS=^
C:\Python39\python.exe^
C:\Python38\python.exe^
C:\Python37\python.exe^
C:\Python310\python.exe^
C:\Python311\python.exe^
C:\Python312\python.exe^
C:\Program Files\Python39\python.exe^
C:\Program Files\Python38\python.exe^
C:\Program Files\Python37\python.exe^
C:\Program Files\Python310\python.exe^
C:\Program Files\Python311\python.exe^
C:\Program Files\Python312\python.exe^
C:\Program Files (x86)\Python39\python.exe^
C:\Program Files (x86)\Python38\python.exe^
C:\Program Files (x86)\Python37\python.exe^
C:\Program Files (x86)\Python310\python.exe^
C:\Program Files (x86)\Python311\python.exe^
C:\Program Files (x86)\Python312\python.exe^
%LOCALAPPDATA%\Programs\Python\Python39\python.exe^
%LOCALAPPDATA%\Programs\Python\Python38\python.exe^
%LOCALAPPDATA%\Programs\Python\Python37\python.exe^
%LOCALAPPDATA%\Programs\Python\Python310\python.exe^
%LOCALAPPDATA%\Programs\Python\Python311\python.exe^
%LOCALAPPDATA%\Programs\Python\Python312\python.exe

for %%p in (%PYTHON_LOCATIONS%) do (
    if exist %%p (
        echo Found Python at: %%p
        set PYTHON_CMD="%%p"
        goto :RUN_SCRIPT
    )
)

:: If we got here, Python wasn't found
echo Python was not found on your system.
echo Please install Python from https://www.python.org/downloads/windows/
echo Make sure to check "Add Python to PATH" during installation.
pause
exit /b 1

:RUN_SCRIPT
echo Running script using %PYTHON_CMD%...

if "%1"=="" (
    echo.
    echo Usage: run_windows.bat [command]
    echo Available commands:
    echo   setup   - Setup the environment
    echo   server  - Run the PRD Generator server
    echo.
    set /p COMMAND=Enter command (setup/server): 
) else (
    set COMMAND=%1
)

%PYTHON_CMD% scripts\run.py %COMMAND%

if %ERRORLEVEL% NEQ 0 (
    echo Error running script.
    pause
)

pause