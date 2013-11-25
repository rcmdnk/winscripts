' Set basic objects
Set wssh = WScript.CreateObject("WScript.Shell")
Set fs = WScript.CreateObject("Scripting.FileSystemObject")
Set nw = WScript.CreateObject("WScript.Network")
Set sh = CreateObject("Shell.Application")

' Basic Values
progFiles = "C:\Program Files"
startMenu = wssh.SpecialFolders("AllUsersPrograms")
defRoot = "C:\Users\" & nw.UserName & "\Downloads"

' Pathes
sName = Wscript.ScriptName
pPath = ""
pName = ""

' Set Folder to install
Set objFolder = sh.BrowseForFolder(0, "インストールするプログラムのフォルダを選択してください", 1, defRoot)

' Check Folder
If objFolder is Nothing then
  WScript.Quit
Else
  pPath = objFolder.Items.Item.Path
  pName = objFolder.Items.Item.Name
End If
Rem MsgBox "プログラムのフォルダ=" & pPath ,,sName

If Not fs.FolderExists(pPath) then
  MsgBox pPath & "がないよ",,sName
  WScript.Quit
Rem Else
Rem   MsgBox pPath & "はあるよ",,sName
End If

If fs.FolderExists(progFiles & "\" & pName) then
  MsgBox pName & "はもうインストールされてるよ",,sName
  WScript.Quit
End If
If fs.FolderExists(startMenu & "\" & pName) then
  MsgBox pName & "はスタートメニューにはあるよ",,sName
  WScript.Quit
End If

' Copy Folder to progFiles
fs.CopyFolder pPath,progFiles & "\" & pName
Rem wssh.Run "cmd /C mklink /D """ & startMenu & "\" & pName & """ """ & _
Rem             progFiles & "\" & pName & """",0,True

' Make symbolic links to startMenu
Set objExec = wssh.Exec("cmd /C mklink /D """ & startMenu & "\" & pName & """ """ _
              & progFiles & "\" & pName & """")
Do Until objExec.StdErr.AtEndOfStream
  strLine = objExec.StdErr.ReadLine
  MsgBox strLine
Loop
