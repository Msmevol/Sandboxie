@echo off
REM Launch OpenCode Desktop in Xdefend Sandbox

set SANDBOX_NAME=DefaultBox
set OPENCODE_PATH=C:\Users\%USERNAME%\AppData\Local\Programs\OpenCode\OpenCode.exe

if not exist "%OPENCODE_PATH%" (
    echo Error: OpenCode not found at %OPENCODE_PATH%
    echo Please install OpenCode Desktop first.
    pause
    exit /b 1
)

echo Starting OpenCode in sandbox: %SANDBOX_NAME%
"C:\Program Files\Xdefend\Start.exe" /box:%SANDBOX_NAME% "%OPENCODE_PATH%"

echo OpenCode launched in sandbox.
