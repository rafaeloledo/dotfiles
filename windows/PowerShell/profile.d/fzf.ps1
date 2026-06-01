# Ctrl+T file picker — mirrors fish/fzf shell integration:
# fuzzy-select files under $PWD (multi-select) and insert them at the
# cursor without executing the command.

function Invoke-FzfFile {
  $fzfArgs = @(
    "--multi",
    "--ansi",
    "--layout=reverse",
    "--height=40%",
    "--border=`"rounded`"",
    "--prompt=`"Files> `"",
    "--bind=`"ctrl-d:preview-page-down`"",
    "--bind=`"ctrl-u:preview-page-up`"",
    "--color=`"bg+:#202224,border:#424947,spinner:#E6DB74,hl:#7E8E91,fg:#6ccfef,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#a6a8aa,prompt:#F92672,hl+:#F92671`""
  )

  if (Get-Command bat -ErrorAction SilentlyContinue) {
    $fzfArgs += @(
      "--preview=`"bat --plain --color=always {}`"",
      "--preview-window=`"right:55%:wrap:border-rounded`""
    )
  }

  $prevCmd = $env:FZF_DEFAULT_COMMAND
  if (Get-Command fd -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
  }

  try {
    $p = [System.Diagnostics.Process]@{StartInfo = @{
      FileName               = "fzf"
      Arguments              = $fzfArgs
      RedirectStandardOutput = $true
      WorkingDirectory       = $PWD
    }}
    $p.Start() | Out-Null

    $lines = New-Object System.Collections.Generic.List[string]
    while (-not $p.StandardOutput.EndOfStream) {
      $lines.Add($p.StandardOutput.ReadLine())
    }
    $p.WaitForExit()
  } finally {
    $env:FZF_DEFAULT_COMMAND = $prevCmd
  }

  if ($lines.Count -gt 0) {
    $quoted = foreach ($l in $lines) {
      if ($l -match "[\s']") { "'" + ($l -replace "'", "''") + "'" } else { $l }
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($quoted -join ' ') + ' ')
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  } else {
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}

# Note: the Ctrl+t binding lives in psreadline.ps1 — it must be set AFTER
# `Set-PSReadLineOption -EditMode Emacs`, which resets all key handlers to
# the Emacs defaults and would otherwise wipe a binding set here.
