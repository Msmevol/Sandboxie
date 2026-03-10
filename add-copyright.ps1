# 批量添加公司版权声明
$files = Get-ChildItem -Path "C:\project\sandboxie\Sandboxie" -Recurse -Include *.cpp,*.c,*.h -File

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # 检查是否已经有 xdefend_sandboxie 版权
    if ($content -match 'Copyright.*xdefend_sandboxie') {
        continue
    }
    
    # 查找版权声明块并添加公司版权
    if ($content -match '(/\*[\s\S]*?Copyright.*?xdefend\.sandboxie\.com[\s\S]*?\*)') {
        $oldBlock = $matches[1]
        $newBlock = $oldBlock -replace '(Copyright.*?xdefend\.sandboxie\.com)', "`$1`r`n * Copyright 2026 xdefend_sandboxie"
        $content = $content -replace [regex]::Escape($oldBlock), $newBlock
        
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $count++
        Write-Host "Updated: $($file.FullName)"
    }
}

Write-Host "`nTotal files updated: $count"
