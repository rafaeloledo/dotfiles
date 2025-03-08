Dim objShell

Set objShell = CreateObject("WScript.Shell")

objShell.Run "D:\dev\scoop\apps\syncthing\current\test.ps1", 0, False

Set objShell = Nothing