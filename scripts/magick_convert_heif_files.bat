@echo off
setlocal enabledelayedexpansion

REM 引数で指定されたディレクトリを取得
set "target_dir=%~1"

REM ディレクトリが指定されていない場合はエラー
if "%target_dir%"=="" (
    echo 使用方法: convert_heif_to_png.bat [対象ディレクトリ]
    exit /b 1
)

REM 出力ディレクトリを作成
set "output_dir=%target_dir%\output"
if not exist "%output_dir%" (
    mkdir "%output_dir%"
)

REM 開始時間を記録
set "start_time=%time%"

REM カウンター初期化
set /a count=0

echo 変換を開始します...

REM .heic ファイルの変換
for %%f in ("%target_dir%\*.heic") do (
    set /a count+=1
    echo [!count!] 変換中: %%~nxf
    magick "%%f" "%output_dir%\%%~nf.png"
)

REM .HEIF ファイルの変換
for %%f in ("%target_dir%\*.HEIF") do (
    set /a count+=1
    echo [!count!] 変換中: %%~nxf
    magick "%%f" "%output_dir%\%%~nf.png"
)

REM 終了時間を記録
@REM not works
set "end_time=%time%"

echo.
echo Finished. Converted Files: %count%
echo Start Time: %start_time%
echo End   Time: %end_time%
echo.

endlocal
