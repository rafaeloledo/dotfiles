Dim objShell

Set objShell = CreateObject("WScript.Shell")

Dim path
path = WScript.Arguments(0)

objShell.Run "neovide " & path, 0, True

Set objShell = Nothing
Set path = Nothing
