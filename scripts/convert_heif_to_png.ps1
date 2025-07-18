
param (
    [string]$TargetDir
)

if (-not (Test-Path $TargetDir)) {
    Write-Host "指定されたディレクトリが存在しません。"
    exit
}

$OutputDir = Join-Path $TargetDir "output"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$StartTime = Get-Date
$Count = 0

Write-Host "変換を開始します..."

Get-ChildItem -Path $TargetDir -Filter *.heic | ForEach-Object {
    $NewName = "$($_.BaseName).png"
    $OutputPath = Join-Path $OutputDir $NewName
    magick $_.FullName $OutputPath
    $Count++
    Write-Host "[$Count] 変換中: $($_.Name)"
}

Get-ChildItem -Path $TargetDir -Filter *.HEIF | ForEach-Object {
    $NewName = "$($_.BaseName).png"
    $OutputPath = Join-Path $OutputDir $NewName
    magick $_.FullName $OutputPath
    $Count++
    Write-Host "[$Count] 変換中: $($_.Name)"
}

$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Host "`n変換が完了しました。合計: $Count ファイル"
Write-Host "開始時間: $StartTime"
Write-Host "終了時間: $EndTime"
Write-Host "所要時間: $($Duration.ToString())"
