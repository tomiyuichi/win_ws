param(
    [string]$InputDir,
    [int]$ScalePercent
)

Add-Type -AssemblyName System.Drawing

# ���f�B���N�g���̃t���p�X
$InputDir = (Resolve-Path $InputDir).Path

# �ꎞ�t�H���_�iASCII ���S�p�X�j
$tempDir = "C:\temp\img_resize_output"
if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

# PNG�t�@�C���擾
$pngFiles = Get-ChildItem -LiteralPath $InputDir -Filter *.png -File
foreach ($file in $pngFiles) {
    $img = [System.Drawing.Image]::FromFile($file.FullName)

    $newW = [Math]::Max(1, [int]($img.Width * $ScalePercent / 100))
    $newH = [Math]::Max(1, [int]($img.Height * $ScalePercent / 100))

    $bitmap = New-Object System.Drawing.Bitmap $newW, $newH
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.DrawImage($img, 0, 0, $newW, $newH)

    $outPath = Join-Path $tempDir $file.Name
    $bitmap.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $graphics.Dispose()
    $bitmap.Dispose()
    $img.Dispose()

    Write-Host "�o��: $outPath"
}

# ---- ��������ړ����� ----
# ���f�B���N�g���� output �t�H���_���쐬
$outputDir = Join-Path $InputDir "output"

# �����t�H���_������ꍇ�͍폜�i�K�v�ɉ����ăR�����g�A�E�g�j
if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}

# �ړ�
Move-Item -Path $tempDir -Destination $outputDir

Write-Host "`n��������: $outputDir �Ƀ��T�C�Y�摜���ړ����܂����B"


# param(
#     [Parameter(Mandatory=$true)]
#     [string]$InputDir,

#     [Parameter(Mandatory=$true)]
#     [int]$ScalePercent
# )

# Set-StrictMode -Version Latest
# $ErrorActionPreference = 'Stop'

# if (-not (Test-Path -LiteralPath $InputDir)) {
#     throw "���̓f�B���N�g�������݂��܂���: $InputDir"
# }

# if ($ScalePercent -le 0) {
#     throw "ScalePercent �� 1 �ȏ�̐����Ŏw�肵�Ă��������B�w��l: $ScalePercent"
# }

# # �o�̓f�B���N�g��
# $outputDir = Join-Path -Path $InputDir -ChildPath 'output'
# if (-not (Test-Path -LiteralPath $outputDir)) {
#     New-Item -ItemType Directory -Path $outputDir | Out-Null
# }

# Add-Type -AssemblyName System.Drawing

# # PNG�擾
# $pngFiles = Get-ChildItem -LiteralPath $InputDir -Filter '*.png' -File
# if (-not $pngFiles) {
#     Write-Warning "PNG�t�@�C����������܂���ł���: $InputDir"
#     return
# }

# foreach ($file in $pngFiles) {
#     Write-Host "������: $($file.Name)" -ForegroundColor Cyan
#     try {
#         # --- ���S�ɓǂݍ��݁iFileStream�o�R�Ń��b�N����j ---
#         $fs = [System.IO.File]::Open($file.FullName, 'Open', 'Read', 'ReadWrite')
#         try {
#             $img = [System.Drawing.Image]::FromStream($fs)
#         }
#         finally {
#             $fs.Close()
#             $fs.Dispose()
#         }

#         $newWidth  = [int]([double]$img.Width  * $ScalePercent / 100)
#         $newHeight = [int]([double]$img.Height * $ScalePercent / 100)

#         # �V����Bitmap�ɕ`��
#         $bitmap = New-Object System.Drawing.Bitmap $newWidth, $newHeight
#         $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
#         try {
#             $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
#             $graphics.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
#             $graphics.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
#             $graphics.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

#             $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)
#         }
#         finally {
#             $graphics.Dispose()
#         }

#         # �ۑ���
#         $outputPath = Join-Path -Path $outputDir -ChildPath $file.Name

#         # �����Ȃ�폜�i���b�N����Ă���Ƃ����ŗ�O��catch�ŕ񍐁j
#         if (Test-Path -LiteralPath $outputPath) {
#             Remove-Item -LiteralPath $outputPath -Force
#         }

#         # �ۑ�
#         $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
#         Write-Host "�ϊ�����: $outputPath" -ForegroundColor Green

#         # ���\�[�X���
#         $bitmap.Dispose()
#         $img.Dispose()
#     }
#     catch {
#         Write-Host "�ϊ����s: $($file.Name)" -ForegroundColor Red
#         Write-Host "�ڍ�: $($_.Exception.Message)"
#         if ($_.Exception.InnerException) {
#             Write-Host "InnerException: $($_.Exception.InnerException.Message)"
#         }
#         Write-Host "�X�^�b�N: $($_.Exception.StackTrace)"
#     }
# }