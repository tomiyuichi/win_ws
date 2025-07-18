param(
    [string]$InputDir,
    [int]$ScalePercent
)

Add-Type -AssemblyName System.Drawing

# 元ディレクトリのフルパス
$InputDir = (Resolve-Path $InputDir).Path

# 一時フォルダ（ASCII 安全パス）
$tempDir = "C:\temp\img_resize_output"
if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

# PNGファイル取得
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

    Write-Host "出力: $outPath"
}

# ---- ここから移動処理 ----
# 元ディレクトリに output フォルダを作成
$outputDir = Join-Path $InputDir "output"

# 既存フォルダがある場合は削除（必要に応じてコメントアウト）
if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}

# 移動
Move-Item -Path $tempDir -Destination $outputDir

Write-Host "`n処理完了: $outputDir にリサイズ画像を移動しました。"


# param(
#     [Parameter(Mandatory=$true)]
#     [string]$InputDir,

#     [Parameter(Mandatory=$true)]
#     [int]$ScalePercent
# )

# Set-StrictMode -Version Latest
# $ErrorActionPreference = 'Stop'

# if (-not (Test-Path -LiteralPath $InputDir)) {
#     throw "入力ディレクトリが存在しません: $InputDir"
# }

# if ($ScalePercent -le 0) {
#     throw "ScalePercent は 1 以上の整数で指定してください。指定値: $ScalePercent"
# }

# # 出力ディレクトリ
# $outputDir = Join-Path -Path $InputDir -ChildPath 'output'
# if (-not (Test-Path -LiteralPath $outputDir)) {
#     New-Item -ItemType Directory -Path $outputDir | Out-Null
# }

# Add-Type -AssemblyName System.Drawing

# # PNG取得
# $pngFiles = Get-ChildItem -LiteralPath $InputDir -Filter '*.png' -File
# if (-not $pngFiles) {
#     Write-Warning "PNGファイルが見つかりませんでした: $InputDir"
#     return
# }

# foreach ($file in $pngFiles) {
#     Write-Host "処理中: $($file.Name)" -ForegroundColor Cyan
#     try {
#         # --- 安全に読み込み（FileStream経由でロック回避） ---
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

#         # 新しいBitmapに描画
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

#         # 保存先
#         $outputPath = Join-Path -Path $outputDir -ChildPath $file.Name

#         # 既存なら削除（ロックされているとここで例外→catchで報告）
#         if (Test-Path -LiteralPath $outputPath) {
#             Remove-Item -LiteralPath $outputPath -Force
#         }

#         # 保存
#         $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
#         Write-Host "変換成功: $outputPath" -ForegroundColor Green

#         # リソース解放
#         $bitmap.Dispose()
#         $img.Dispose()
#     }
#     catch {
#         Write-Host "変換失敗: $($file.Name)" -ForegroundColor Red
#         Write-Host "詳細: $($_.Exception.Message)"
#         if ($_.Exception.InnerException) {
#             Write-Host "InnerException: $($_.Exception.InnerException.Message)"
#         }
#         Write-Host "スタック: $($_.Exception.StackTrace)"
#     }
# }