@echo off
echo === Xdefend Deploy ===

echo Stopping service...
sc stop SbieSvc
timeout /t 2 /nobreak >nul

echo Backing up...
set BACKUP_DIR=C:\Xdefend-Backup\%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%
set BACKUP_DIR=%BACKUP_DIR: =0%
mkdir "%BACKUP_DIR%"
xcopy "C:\Program Files\Xdefend\*" "%BACKUP_DIR%\" /E /I /Y /Q
echo Backup to: %BACKUP_DIR%

echo Copying new files...
for %%f in (C:\project\Sandboxie\Sandboxie-Build-x64\x64\*) do (
    if not "%%~xf"==".sys" (
        copy /Y "%%f" "C:\Program Files\Xdefend\" >nul
        echo   Copied: %%~nxf
    )
)

copy /Y "C:\project\Sandboxie\Sandboxie-Build-x64\x86\SbieDll.dll" "C:\Program Files\Xdefend\32\SbieDll.dll" >nul
copy /Y "C:\project\Sandboxie\Sandboxie-Build-x64\x86\SbieSvc.exe" "C:\Program Files\Xdefend\32\SbieSvc.exe" >nul

echo Starting service...
sc start SbieSvc
timeout /t 2 /nobreak >nul

echo Verifying...
sc query SbieSvc
sc query SbieDrv

echo.
echo === Deploy Complete ===
pause
