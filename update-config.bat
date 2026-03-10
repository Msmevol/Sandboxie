@echo off
REM Update Sandboxie Configuration
REM Run as Administrator

echo Backing up current configuration...
copy "C:\Windows\Sandboxie.ini" "C:\Windows\Sandboxie.ini.backup-%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%"

echo Writing new configuration...
(
echo [GlobalSettings]
echo Template=7zipShellEx
echo Template=WindowsRasMan
echo Template=NotepadPlusPlus_fix
echo Template=WindowsLive
echo Template=Edge_Fix
echo Template=OfficeLicensing
echo Template=OfficeClickToRun
echo.
echo [DefaultBox]
echo ConfigLevel=10
echo AutoRecover=y
echo BlockNetworkFiles=y
echo Template=OpenSmartCard
echo Template=OpenBluetooth
echo Template=SkipHook
echo Template=FileCopy
echo Template=qWave
echo Template=BlockPorts
echo Template=LingerPrograms
echo Template=AutoRecoverIgnore
echo RecoverFolder=%%{374DE290-123F-4565-9164-39C4925E467B}%%
echo RecoverFolder=%%Personal%%
echo RecoverFolder=%%Desktop%%
echo BorderColor=#00ffff,ttl,6,192,in
echo Enabled=y
echo AllowRawDiskRead=y
echo NotifyDirectDiskAccess=y
echo EnableEFS=y
echo ProcessGroup=,notepad.exe,cmd.exe
echo.
echo [UserSettings_15800203]
echo SbieCtrl_UserName=d00845463
echo SbieCtrl_BoxExpandedView=DefaultBox
echo SbieCtrl_NextUpdateCheck=1773109204
echo SbieCtrl_WindowCoords=325,293,1238,632
echo SbieCtrl_ActiveView=40021
echo SbieCtrl_AutoApplySettings=n
echo SbieCtrl_ProcessViewColumnWidths=250,70,300
echo SbieCtrl_AutoStartAgent=SandMan.exe -autorun
echo BoxGrouping=:DefaultBox,OpenCodeBox
echo.
echo [OpenCodeBox]
echo Enabled=y
echo EnableObjectFiltering=y
echo ConfigLevel=10
echo NoSecurityIsolation=y
echo Template=Edge_Fix
echo ExternalManifestHack=msedgewebview2.exe,y
echo BlockNetworkFiles=n
echo AllowRawDiskRead=y
echo NotifyDirectDiskAccess=n
echo ProcessGroup=,opencode.exe,node.exe,cmd.exe,powershell.exe,git.exe
echo RecoverFolder=%%Personal%%
echo RecoverFolder=%%Desktop%%
echo OpenFilePath=*
echo ClosedFilePath=D:\test
echo ClosedFilePath=D:\test*
echo HideNonSystemProcesses=y
echo BorderColor=#ff6600,ttl,4,192,in
echo Template=BlockAccessWMI
) > "C:\Windows\Sandboxie.ini"

echo.
echo Configuration updated successfully!
echo Restarting Xdefend service...
net stop SbieSvc
net start SbieSvc

echo.
echo Done! Press any key to exit.
pause >nul
