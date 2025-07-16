# Obtém a janela ativa
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")]
        public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
    }
"@

$activeWindow = [Win32]::GetForegroundWindow()
$processId = 0
[Win32]::GetWindowThreadProcessId($activeWindow, [ref]$processId)

if ($processId -ne 0) {
  try {
    # Termina o processo forçadamente
    Stop-Process -Id $processId -Force
    Write-Host "Processo $processId terminado com sucesso."
  }
  catch {
    Write-Host "Erro ao terminar o processo: $($_.Exception.Message)"
  }
} else {
  Write-Host "Nenhuma janela ativa encontrada."
}