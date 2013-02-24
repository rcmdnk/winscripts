@echo off
echo "プログラムのフォルダ名と親ディレクトリへのパスを入力してください"
set /p dir="プログラムのフォルダ名:"

:label1
set dpath="C:\Users\%username%\Downloads"
set /p flag="%dpath%をパスにします？(y/n):"
if "%flag%" == "y" (

goto label2
) else (
  if "%flag%" == "n" (
    set /p dpath="パスを入力して下さい:"
    goto label2
  )
  goto label1
)
:label2

if exist "%dpath%\%dir%"  (
  if exist "C:\Program Files\%dir%" (
    echo %dir%はインストール済みです
　　pause
  ) else (
    echo インストールします
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
    echo %dir%をインストールしました
  　pause
  )
) else (
  echo フォルダがないよ
　pause
)
