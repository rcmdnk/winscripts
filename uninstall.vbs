Const BITRECYCLEBIN = 10
Dim sName, defRoot, pPath, pName
sName = Wscript.ScriptName

Set WSHShell = WScript.CreateObject("WScript.Shell")
Set Fs = WScript.CreateObject("Scripting.FileSystemObject")

Dim progFiles, startMenu
progFiles = "C:\Program Files"
startMenu = WSHShell.SpecialFolders("AllUsersPrograms")

Set Shell = CreateObject("Shell.Application")
Set objFolder = Shell.BrowseForFolder(0, "アンインストールするプログラムのフォルダを選択してください", 1,progFiles)

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

If Not Fs.FolderExists(pPath) then
  MsgBox pPath & "がないよ",,sName
  WScript.Quit
ElseIf pPath = progFiles then
  MsgBox pPath & "は消せないよ",,sName
  WScript.Quit
' Else
'   MsgBox pPath & "はあるよ",,sName
End If

' Fs.DeleteFolder pPath
Dim folder, folderItem, fileName
Set folder = Shell.NameSpace(progFiles)
Set folderItem = folder.ParseName(pName)
Shell.NameSpace(BITRECYCLEBIN).MoveHere folderItem
Do While Not folder.ParseName(pName) Is Nothing
  WScript.Sleep 100
Loop

' Fs.DeleteFolder startMenu & "\" & pName
Set objExec = WSHShell.Exec("cmd /C rd """ & startMenu & "\" & pName & """")
Do Until objExec.StdErr.AtEndOfStream
  strLine = objExec.StdErr.ReadLine
  MsgBox strLine,,sName
Loop
