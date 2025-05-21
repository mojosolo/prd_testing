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
echo Running script...

set CMD_ARG=%1
echo DEBUG: CMD_ARG is [\"%CMD_ARG%\"]

REM === Determine COMMAND_INPUT based on CMD_ARG ===
if "%CMD_ARG%"=="" goto :PROMPT_FOR_COMMAND
goto :ARG_IS_PROVIDED

:PROMPT_FOR_COMMAND
echo DEBUG: CMD_ARG is empty. Prompting for command.
echo.
echo Usage: run_windows.bat [command]
echo Available commands:
echo   setup   - Setup the environment
echo   server  - Run the PRD Generator server
echo.
set /p COMMAND_INPUT_PROMPT=Enter command (setup/server):
set COMMAND_INPUT=%COMMAND_INPUT_PROMPT%
echo DEBUG: COMMAND_INPUT from prompt is [\"%COMMAND_INPUT%\"]
goto :CONTINUE_AFTER_INPUT_SET

:ARG_IS_PROVIDED
echo DEBUG: CMD_ARG was provided.
set COMMAND_INPUT=%CMD_ARG%
echo DEBUG: COMMAND_INPUT from arg is [\"%COMMAND_INPUT%\"]
goto :CONTINUE_AFTER_INPUT_SET

:CONTINUE_AFTER_INPUT_SET
echo DEBUG: Final COMMAND_INPUT is [\"%COMMAND_INPUT%\"]
echo DEBUG: About to check command type...

if /I "%COMMAND_INPUT%"=="server" (
    echo DEBUG: Matched 'server' command.
    echo Running server using mcp dev...
    REM Assuming prd_server.py is in the root (same directory as run_windows.bat)
    mcp dev prd_server.py
) else if /I "%COMMAND_INPUT%"=="setup" (
    echo DEBUG: Matched 'setup' command.
    REM This part still uses the Python found earlier
    if "%PYTHON_CMD%"=="" (
        echo Python command was not found, cannot run setup.
        echo Please ensure Python is installed and detectable by this script.
        pause
        exit /b 1
    )
    echo Running setup using %PYTHON_CMD%...
    %PYTHON_CMD% scripts\run.py setup
) else (
    echo DEBUG: Unknown command.
    echo Unknown command: "%COMMAND_INPUT%"
    echo Please use 'setup' or 'server'.
)

echo DEBUG: After command execution block. ERRORLEVEL is %ERRORLEVEL%

if %ERRORLEVEL% NEQ 0 (
    echo Error running the command.
    pause
)

pause