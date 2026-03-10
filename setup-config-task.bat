@echo off
REM Create scheduled task for updating Sandboxie config

schtasks /create /tn "XdefendUpdateConfig" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\project\Sandboxie\update-config.ps1" /sc once /st 00:00 /rl highest /f

echo Task created successfully!
echo.
echo To update config, run: schtasks /run /tn XdefendUpdateConfig
pause
