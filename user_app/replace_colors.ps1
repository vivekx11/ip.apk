# PowerShell script to replace pink colors with yellow colors in all Dart files

$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

$replacements = @{
    'primaryPink' = 'primaryYellow'
    'darkPink' = 'darkYellow'
    'lightPink' = 'lightYellow'
    'softPink' = 'softYellow'
    'palePink' = 'paleYellow'
    'pinkGrey' = 'yellowGrey'
    'warningYellow' = 'warningAmber'
}

$totalFiles = 0
$totalReplacements = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileReplacements = 0
    
    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        if ($content -match $old) {
            $content = $content -replace $old, $new
            $count = ([regex]::Matches($originalContent, $old)).Count
            $fileReplacements += $count
        }
    }
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $totalFiles++
        $totalReplacements += $fileReplacements
        Write-Host "Updated: $($file.Name) - $fileReplacements replacements" -ForegroundColor Green
    }
}

Write-Host "`nTotal files updated: $totalFiles" -ForegroundColor Cyan
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Cyan
Write-Host "`nColor replacement complete!" -ForegroundColor Green
