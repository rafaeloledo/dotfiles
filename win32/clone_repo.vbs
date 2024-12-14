Dim objShell
Set objShell = CreateObject("WScript.Shell")

Dim repoURL, repoPath
repoURL = WScript.Arguments(0)

Dim regex
Set regex = New RegExp
regex.Pattern = "/([^/]+)(?:\.git)?$"
regex.IgnoreCase = True

Dim match
Set match = regex.Execute(repoURL)

repoPath = "C:\dev\repos\github\" & match(0).SubMatches(0)

objShell.Run "git clone --depth 1 " & repoURL & " " & repoPath, 0, True

Set objShell = Nothing
Set regex = Nothing
Set match = Nothing