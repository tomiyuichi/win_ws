@echo off
setlocal enabledelayedexpansion

REM �����Ŏw�肳�ꂽ�f�B���N�g�����擾
set "target_dir=%~1"

REM �f�B���N�g�����w�肳��Ă��Ȃ��ꍇ�̓G���[
if "%target_dir%"=="" (
    echo �g�p���@: convert_heif_to_png.bat [�Ώۃf�B���N�g��]
    exit /b 1
)

REM �o�̓f�B���N�g�����쐬
set "output_dir=%target_dir%\output"
if not exist "%output_dir%" (
    mkdir "%output_dir%"
)

REM �J�n���Ԃ��L�^
set "start_time=%time%"

REM �J�E���^�[������
set /a count=0

echo �ϊ����J�n���܂�...

REM .heic �t�@�C���̕ϊ�
for %%f in ("%target_dir%\*.heic") do (
    set /a count+=1
    echo [!count!] �ϊ���: %%~nxf
    magick "%%f" "%output_dir%\%%~nf.png"
)

REM .HEIF �t�@�C���̕ϊ�
for %%f in ("%target_dir%\*.HEIF") do (
    set /a count+=1
    echo [!count!] �ϊ���: %%~nxf
    magick "%%f" "%output_dir%\%%~nf.png"
)

REM �I�����Ԃ��L�^
@REM not works
set "end_time=%time%"

echo.
echo Finished. Converted Files: %count%
echo Start Time: %start_time%
echo End   Time: %end_time%
echo.

endlocal
