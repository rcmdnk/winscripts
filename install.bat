@echo off
echo "�v���O�����̃t�H���_���Ɛe�f�B���N�g���ւ̃p�X����͂��Ă�������"
set /p dir="�v���O�����̃t�H���_��:"

:label1
set dpath="C:\Users\%username%\Downloads"
set /p flag="%dpath%���p�X�ɂ��܂��H(y/n):"
if "%flag%" == "y" (

goto label2
) else (
  if "%flag%" == "n" (
    set /p dpath="�p�X����͂��ĉ�����:"
    goto label2
  )
  goto label1
)
:label2

if exist "%dpath%\%dir%"  (
  if exist "C:\Program Files\%dir%" (
    echo %dir%�̓C���X�g�[���ς݂ł�
�@�@pause
  ) else (
    echo �C���X�g�[�����܂�
    echo %dpath%\%dir%
    xcopy "%dpath%\%dir%" "C:\Program Files\%dir%" /i /s
rem    md "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\%dir%"
    cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
    mklink /D %dir% "C:\Program Files\%dir%" 
rem    cd "C:\Program Files\%dir%"
rem    for %%i in ( "*.exe" ) do (
rem      echo %%i
rem      cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\%dir%
rem      mklink %%i "C:\Program Files\%dir%\%%i" 
rem    )
    echo %dir%���C���X�g�[�����܂���
  �@pause
  )
) else (
  echo �t�H���_���Ȃ���
�@pause
)
