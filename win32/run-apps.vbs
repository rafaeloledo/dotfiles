Dim objShell

Set objShell = CreateObject("WScript.Shell")

objShell.Run "C:\dev\.dotfiles\win32\autohotkey\base.ahk", 1, False
WScript.Sleep(500)
objShell.Run "wezterm-gui start", 1, False
WScript.Sleep(500)
objShell.Run "C:\dev\scoop\apps\googlechrome\current\chrome.exe", 1, False
WScript.Sleep(500)
' objShell.Run "C:\dev\scoop\apps\neovide\current\neovide.exe", 1, False
' WScript.Sleep(500)
objShell.Run "C:\dev\scoop\apps\sublime-text\current\sublime_text.exe", 1, False
WScript.Sleep(500)
objShell.Run "C:\dev\scoop\apps\vscode\current\Code.exe", 1, False
WScript.Sleep(500)
' objShell.Run "C:\Users\rafae\Downloads\cslol-manager\cslol-manager.exe", 1, False
' WScript.Sleep(500)
' objShell.Run "C:\Users\rafae\Downloads\lol_auto_accept.exe", 1, False
' WScript.Sleep(500)
objShell.Run """C:\Program Files\ExitLag\ExitLag.exe""", 1, False

Set objShell = Nothing
