Const BITRECYCLEBIN = 10
Dim sName, defRoot, pPath, pName
sName = Wscript.ScriptName

Set WSHShell = WScript.CreateObject("WScript.Shell")
Set Fs = WScript.CreateObject("Scripting.FileSystemObject")

Dim progFiles, startMenu
progFiles = "C:\Program Files"
startMenu = WSHShell.SpecialFolders("AllUsersPrograms")

Set Shell = CreateObject("Shell.Application")
Set objFolder = Shell.BrowseForFolder(0, "�A���C���X�g�[������v���O�����̃t�H���_��I�����Ă�������", 1,progFiles)

If objFolder is Nothing then 
  WScript.Quit
Else
  pPath = objFolder.Items.Item.Path
  pName = objFolder.Items.Item.Name
End If
Rem MsgBox "�v���O�����̃t�H���_=" & pPath ,,sName

If Not Fs.FolderExists(pPath) then
  MsgBox pPath & "���Ȃ���",,sName
  WScript.Quit
Rem Else
Rem   MsgBox pPath & "�͂����",,sName
End If

Rem Fs.DeleteFolder pPath
Dim folder, folderItem, fileName
Set folder = Shell.NameSpace(progFiles)
Set folderItem = folder.ParseName(pName)
Shell.NameSpace(BITRECYCLEBIN).MoveHere folderItem
Do While Not folder.ParseName(pName) Is Nothing
  WScript.Sleep 100
Loop

Rem Fs.DeleteFolder startMenu & "\" & pName
Set objExec = WSHShell.Exec("cmd /C rd """ & startMenu & "\" & pName & """")
Do Until objExec.StdErr.AtEndOfStream
  strLine = objExec.StdErr.ReadLine
  MsgBox strLine
Loop
