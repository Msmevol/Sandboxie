# Update Sandboxie Configuration
# Run as Administrator

$configPath = "C:\Windows\Sandboxie.ini"
$backupPath = "C:\Windows\Sandboxie.ini.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Backing up current configuration..."
Copy-Item $configPath $backupPath

Write-Host "Writing new configuration..."
$config = @"
#
#  Sandboxie configuration file
#

[GlobalSettings]
Template=7zipShellEx
Template=WindowsRasMan
Template=NotepadPlusPlus_fix
Template=WindowsLive
Template=Edge_Fix
Template=OfficeLicensing
Template=OfficeClickToRun

[DefaultBox]
ConfigLevel=10
AutoRecover=y
BlockNetworkFiles=y
Template=OpenSmartCard
Template=OpenBluetooth
Template=SkipHook
Template=FileCopy
Template=qWave
Template=BlockPorts
Template=LingerPrograms
Template=AutoRecoverIgnore
RecoverFolder=%{374DE290-123F-4565-9164-39C4925E467B}%
RecoverFolder=%Personal%
RecoverFolder=%Desktop%
BorderColor=#00ffff,ttl,6,192,in
Enabled=y
AllowRawDiskRead=y
NotifyDirectDiskAccess=y
EnableEFS=y
ProcessGroup=,notepad.exe,cmd.exe

[UserSettings_15800203]
SbieCtrl_UserName=d00845463
SbieCtrl_BoxExpandedView=DefaultBox
SbieCtrl_NextUpdateCheck=1773109204
SbieCtrl_WindowCoords=325,293,1238,632
SbieCtrl_ActiveView=40021
SbieCtrl_AutoApplySettings=n
SbieCtrl_ProcessViewColumnWidths=250,70,300
SbieCtrl_AutoStartAgent=SandMan.exe -autorun
BoxGrouping=:DefaultBox,OpenCodeBox

[OpenCodeBox]
Enabled=y
EnableObjectFiltering=y
ConfigLevel=10
NoSecurityIsolation=y
Template=Edge_Fix
ExternalManifestHack=msedgewebview2.exe,y
BlockNetworkFiles=n
AllowRawDiskRead=y
NotifyDirectDiskAccess=n
ProcessGroup=,opencode.exe,node.exe,cmd.exe,powershell.exe,git.exe
RecoverFolder=%Personal%
RecoverFolder=%Desktop%
OpenFilePath=*
ClosedFilePath=D:\test
ClosedFilePath=D:\test*
HideNonSystemProcesses=y
BorderColor=#ff6600,ttl,4,192,in
Template=BlockAccessWMI
"@

[System.IO.File]::WriteAllText($configPath, $config, [System.Text.Encoding]::Unicode)

Write-Host "Restarting Xdefend service..."
Restart-Service SbieSvc

Write-Host "Done!"
