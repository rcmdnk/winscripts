' Set basic objects
Set wssh = WScript.CreateObject("WScript.Shell")
Set fs = WScript.CreateObject("Scripting.FileSystemObject")
Set sh = CreateObject("Shell.Application")

' Basic Values
progFiles = "C:\Program Files"
startMenu = wssh.SpecialFolders("AllUsersPrograms")
vDirRecyclebin = 10

' Pathes
sName = Wscript.ScriptName
pPath = ""
pName = ""

' Set Folder to uninstall
Set objFolder = sh.BrowseForFolder(0, "アンインストールするプログラムのフォルダを選択してください", 1, progFiles)

' Check Folder
If objFolder is Nothing then
  WScript.Quit
Else
  pPath = objFolder.Items.Item.Path
  pName = objFolder.Items.Item.Name
End If
ans = Msgbox(pPath & "を消しても良いですか？", vbYesNo, "Delete Program")

If ans = vbNo Then
    WScript.Quit
End If

If Not fs.FolderExists(pPath) then
  MsgBox pPath & "がないよ",,sName
  WScript.Quit
ElseIf pPath = progFiles then
  MsgBox pPath & "は消せないよ",,sName
  WScript.Quit
Rem Else
Rem   MsgBox pPath & "はあるよ",,sName
End If

' Remove folder from progFiles
Rem fs.DeleteFolder pPath
Set folder = sh.NameSpace(progFiles)
Set folderItem = folder.ParseName(pName)
sh.NameSpace(vDirrecyclebin).MoveHere folderItem
Do While Not folder.ParseName(pName) Is Nothing
  WScript.Sleep 100
Loop

' Remove Folder from startMenu
Rem fs.DeleteFolder startMenu & "\" & pName
Set objExec = wssh.Exec("cmd /C rd """ & startMenu & "\" & pName & """")
Do Until objExec.StdErr.AtEndOfStream
  strLine = objExec.StdErr.ReadLine
  MsgBox strLine,,sName
Loop
