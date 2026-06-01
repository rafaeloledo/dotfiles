function ExportCurrentPath () {
  $existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  ($existingPath -notlike "*$pwd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $pwd, 'User') 2>&1>$null
}

function ExportPath ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'User')
}

function GlobalExport ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'Machine')
}

# Just for registering the Exports, run this only one time in the cli
# Export 'C:\dev\projects\lol_auto_accept\lol_auto_accept\bin\Debug' > $null
# Export 'C:\ProgramData\chocolatey\lib\asmspy\tools' > $null
# Export 'C:\dev\scoop\apps\autohotkey\current\Compiler' > $null
# Export 'C:\dev\scoop\apps\scoop\current\bin' > $null
# Export 'C:\Users\rafae\AppData\Local\Obsidian' > $null
# Export 'C:\dev\scoop\shims' > $null
