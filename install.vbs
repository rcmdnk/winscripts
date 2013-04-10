Dim sName, defRoot, pPath, pName
sName = Wscript.ScriptName

Set WSHShell = WScript.CreateObject("WScript.Shell")
Set Fs = WScript.CreateObject("Scripting.FileSystemObject")

username = WSHShell.ExpandEnvironmentStrings("%USERNAME%")
defRoot = "C:\Users\" & username & "\Downloads"

Set Shell = CreateObject("Shell.Application")

Set objFolder = Shell.BrowseForFolder(0, "インストールするプログラムのフォルダを選択してください", 1,defRoot)

If objFolder is Nothing then 
  WScript.Quit
Else
  pPath = objFolder.Items.Item.Path
  pName = objFolder.Items.Item.Name
End If
Rem MsgBox "プログラムのフォルダ=" & pPath ,,sName

If Not Fs.FolderExists(pPath) then
  MsgBox pPath & "がないよ",,sName
  WScript.Quit
Rem Else
Rem   MsgBox pPath & "はあるよ",,sName
End If

Dim progFiles, startMenu
progFiles = "C:\Program Files"
startMenu = WSHShell.SpecialFolders("AllUsersPrograms")

If Fs.FolderExists(progFiles & "\" & pName) then
  MsgBox pName & "はもうインストールされてるよ",,sName
  WScript.Quit
End If
If Fs.FolderExists(startMenu & "\" & pName) then
  MsgBox pName & "はスタートメニューにはあるよ",,sName
  WScript.Quit
End If


Fs.CopyFolder pPath,progFiles & "\" & pName
Rem WSHShell.Run "cmd /C mklink /D """ & startMenu & "\" & pName & """ """ & _
Rem             progFiles & "\" & pName & """",0,True
Set objExec = WSHShell.Exec("cmd /C mklink /D """ & startMenu & "\" & pName & """ """ _
              & progFiles & "\" & pName & """")
Do Until objExec.StdErr.AtEndOfStream
  strLine = objExec.StdErr.ReadLine
  MsgBox strLine
Loop
