# 停止服务
sc.exe stop SbieSvc
Start-Sleep -Seconds 2

# 备份
$backupDir = "C:\Xdefend-Backup\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force
Copy-Item "C:\Program Files\Xdefend\*" -Destination $backupDir -Recurse -Force
Write-Host "备份到: $backupDir"

# 替换文件（排除 .sys）
Get-ChildItem "C:\project\Sandboxie\Sandboxie-Build-x64\x64\*" -Exclude "*.sys" | ForEach-Object {
    Copy-Item $_.FullName -Destination "C:\Program Files\Xdefend" -Force
    Write-Host "复制: $($_.Name)"
}

# x86 文件
Copy-Item "C:\project\Sandboxie\Sandboxie-Build-x64\x86\SbieDll.dll" -Destination "C:\Program Files\Xdefend\32\SbieDll.dll" -Force
Copy-Item "C:\project\Sandboxie\Sandboxie-Build-x64\x86\SbieSvc.exe" -Destination "C:\Program Files\Xdefend\32\SbieSvc.exe" -Force

# 启动服务
sc.exe start SbieSvc
Start-Sleep -Seconds 2

# 验证
sc.exe query SbieSvc
sc.exe query SbieDrv
