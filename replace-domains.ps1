# 批量替换域名脚本
$files = Get-ChildItem -Path "C:\project\sandboxie\Sandboxie" -Recurse -Include *.cpp,*.c,*.h,*.rc -File

$replacements = @(
    @('www.sandboxie.com', 'xdefend.sandboxie.com'),
    @('sandboxie-plus.com', 'xdefend.sandboxie.com'),
    @('Sandboxie-Plus.com', 'xdefend.sandboxie.com'),
    @('xanasoft.com', 'xdefend.sandboxie.com'),
    @('sandboxie.com', 'xdefend.sandboxie.com')
)

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    foreach ($pair in $replacements) {
        $old = $pair[0]
        $new = $pair[1]
        if ($content -match [regex]::Escape($old)) {
            $content = $content -replace [regex]::Escape($old), $new
            $modified = $true
        }
    }
    
    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $count++
        Write-Host "Updated: $($file.FullName)"
    }
}

Write-Host "`nTotal files updated: $count"
