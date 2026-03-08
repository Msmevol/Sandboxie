@echo off
echo ========================================
echo  Xdefend Deploy - Task Setup
echo ========================================
echo.
echo This will create a scheduled task that:
echo - Runs with HIGHEST privileges
echo - Can be triggered without UAC prompts
echo - Executes the Python deployment script
echo.
echo Press any key to continue...
pause >nul

REM Use PowerShell to create the task (more reliable)
powershell -Command "$action = New-ScheduledTaskAction -Execute 'C:\Users\mxmevol\AppData\Local\Programs\Python\Python312\python.exe' -Argument 'C:\project\Sandboxie\deploy.py'; $principal = New-ScheduledTaskPrincipal -UserId '%USERNAME%' -RunLevel Highest; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName 'XdefendDeploy' -Action $action -Principal $principal -Settings $settings -Force"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo  SUCCESS - Task Created!
    echo ========================================
    echo.
    echo Task Name: XdefendDeploy
    echo.
    echo To run deployment from now on:
    echo   schtasks /run /tn XdefendDeploy
    echo.
    echo Or use Python wrapper:
    echo   python C:\project\Sandboxie\deploy-task.py
    echo.
) else (
    echo.
    echo ========================================
    echo  FAILED - Access Denied
    echo ========================================
    echo.
    echo Please run this script as Administrator:
    echo   Right-click setup-task.bat
    echo   Select "Run as administrator"
    echo.
)

pause
