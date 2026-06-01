Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord "Alt+l" -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function NextWord
Set-PSReadLineKeyHandler -Chord "Ctrl+n" -Function NextSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+p" -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
Set-PSReadLineKeyHandler -Chord "Ctrl+z" -Function Undo
Set-PSReadLineKeyHandler -Chord "Ctrl+o" -ScriptBlock { MyFzf } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock { MyRg  } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+t" -ScriptBlock { Invoke-FzfFile } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+u" -ScriptBlock { scoop update * }
