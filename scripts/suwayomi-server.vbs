Dim WshShell, fso, currentDir
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Set the working directory to the application folder
WshShell.CurrentDirectory = currentDir

' Run the launcher batch file hidden (0) and do not wait for it to finish (False)
WshShell.Run chr(34) & "Suwayomi Launcher.bat" & chr(34), 0, False