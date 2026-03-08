# Xdefend 部署脚本（不替换驱动）
# 需要管理员权限运行

param(
    [string]$BuildPath = "C:\project\Sandboxie\Sandboxie-Build-x64",
    [string]$InstallDir = "C:\Program Files\Xdefend"
)

# 检查管理员权限
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "错误: 需要管理员权限运行此脚本" -ForegroundColor Red
    Write-Host "请右键点击 PowerShell，选择 '以管理员身份运行'" -ForegroundColor Yellow
    exit 1
}

Write-Host "=== Xdefend 部署脚本（不替换驱动）===" -ForegroundColor Cyan

# 1. 停止服务
Write-Host "`n[1/5] 停止服务..." -ForegroundColor Yellow
sc.exe stop SbieSvc 2>&1 | Out-Null
Start-Sleep -Seconds 2

# 2. 备份旧文件
Write-Host "[2/5] 备份旧文件..." -ForegroundColor Yellow
$backupDir = "C:\Xdefend-Backup\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item "$InstallDir\*" -Destination $backupDir -Recurse -Force
Write-Host "    备份到: $backupDir" -ForegroundColor Gray

# 3. 替换新文件（排除驱动）
Write-Host "[3/5] 替换新文件（不包括驱动）..." -ForegroundColor Yellow

# x64 文件（排除 .sys）
Get-ChildItem "$BuildPath\x64\*" -Exclude "*.sys" | ForEach-Object {
    Copy-Item $_.FullName -Destination $InstallDir -Force
    Write-Host "    复制: $($_.Name)" -ForegroundColor Gray
}

# x86 文件
if (Test-Path "$InstallDir\32") {
    Copy-Item "$BuildPath\x86\SbieDll.dll" -Destination "$InstallDir\32\SbieDll.dll" -Force
    Copy-Item "$BuildPath\x86\SbieSvc.exe" -Destination "$InstallDir\32\SbieSvc.exe" -Force
    Write-Host "    复制: x86 DLL 和 SVC" -ForegroundColor Gray
}

# 4. 启动服务
Write-Host "[4/5] 启动服务..." -ForegroundColor Yellow
sc.exe start SbieSvc 2>&1 | Out-Null
Start-Sleep -Seconds 2

# 5. 验证服务状态
Write-Host "[5/5] 验证服务状态..." -ForegroundColor Yellow
$svcStatus = sc.exe query SbieSvc
$drvStatus = sc.exe query SbieDrv

if ($svcStatus -match "RUNNING" -and $drvStatus -match "RUNNING") {
    Write-Host "`n✅ 部署成功！服务运行正常" -ForegroundColor Green
} else {
    Write-Host "`n❌ 警告：服务可能未正常启动" -ForegroundColor Red
    Write-Host "SbieSvc 状态:" -ForegroundColor Yellow
    sc.exe query SbieSvc
    Write-Host "`nSbieDrv 状态:" -ForegroundColor Yellow
    sc.exe query SbieDrv
}

Write-Host "`n=== 部署完成 ===" -ForegroundColor Cyan
Write-Host "备份位置: $backupDir" -ForegroundColor Gray
Write-Host "注意: 驱动文件未被替换" -ForegroundColor Yellow
