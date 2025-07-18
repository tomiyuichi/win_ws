
param (
    [string]$TargetDir
)

if (-not (Test-Path $TargetDir)) {
    Write-Host "�w�肳�ꂽ�f�B���N�g�������݂��܂���B"
    exit
}

$OutputDir = Join-Path $TargetDir "output"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$StartTime = Get-Date
$Count = 0

Write-Host "�ϊ����J�n���܂�..."

Get-ChildItem -Path $TargetDir -Filter *.heic | ForEach-Object {
    $NewName = "$($_.BaseName).png"
    $OutputPath = Join-Path $OutputDir $NewName
    magick $_.FullName $OutputPath
    $Count++
    Write-Host "[$Count] �ϊ���: $($_.Name)"
}

Get-ChildItem -Path $TargetDir -Filter *.HEIF | ForEach-Object {
    $NewName = "$($_.BaseName).png"
    $OutputPath = Join-Path $OutputDir $NewName
    magick $_.FullName $OutputPath
    $Count++
    Write-Host "[$Count] �ϊ���: $($_.Name)"
}

$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Host "`n�ϊ����������܂����B���v: $Count �t�@�C��"
Write-Host "�J�n����: $StartTime"
Write-Host "�I������: $EndTime"
Write-Host "���v����: $($Duration.ToString())"
