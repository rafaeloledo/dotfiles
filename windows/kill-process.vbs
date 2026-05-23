Dim objShell
Set objShell = CreateObject("WScript.Shell")
objShell.Run "taskkill /f /pid " & WScript.Arguments(0), 0, False
Set objShell = Nothing