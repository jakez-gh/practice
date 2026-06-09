@echo off
setlocal

set SCRIPT_DIR=%~dp0
set VENV=%SCRIPT_DIR%.venv

if not exist "%VENV%" (
    echo Creating virtualenv...
    python -m venv "%VENV%"
)

call "%VENV%\Scripts\activate.bat"

if not exist "%VENV%\.deps_installed" (
    goto install
)

for /f %%i in ('robocopy "%SCRIPT_DIR%" "%SCRIPT_DIR%" requirements.txt /l /njh /njs /ndl /nc /ns ^| find "requirements.txt"') do goto install
for /f "tokens=*" %%i in ('dir /b /o-d "%SCRIPT_DIR%requirements.txt" "%VENV%\.deps_installed" 2^>nul') do (
    if "%%i"=="requirements.txt" goto install
)
goto run

:install
echo Installing dependencies...
pip install -q -r "%SCRIPT_DIR%requirements.txt"
type nul > "%VENV%\.deps_installed"

:run
python "%SCRIPT_DIR%anthropic_client.py" %*
