Set sh = CreateObject("WScript.Shell")
cfg = sh.ExpandEnvironmentStrings("%USERPROFILE%\.config\kanata\kanata.kbd")
exe = sh.ExpandEnvironmentStrings("%USERPROFILE%\scoop\apps\kanata\current\kanata.exe")
If Not (CreateObject("Scripting.FileSystemObject")).FileExists(exe) Then exe = "C:\scoop\apps\kanata\current\kanata.exe"
If Not (CreateObject("Scripting.FileSystemObject")).FileExists(exe) Then exe = sh.ExpandEnvironmentStrings("%USERPROFILE%\kanata_windows_gui_winIOv2_x64.exe")
sh.Run """" & exe & """ --cfg """ & cfg & """", 0, False
