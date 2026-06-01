function gc { git checkout -b @args }
function gci { git commit @args }
function gst { git status @args }
function gps { git push @args }
function gpl { git pull @args }
function gl { git log --graph @args }
function gw { git worktree @args }
function gcl { git clone @args }
function gco { git checkout @args }
function gbr { git branch @args }
function gd { git diff @args }
function gaa { git add . @args }
function gf { git fetch @args }
function gs { git stash @args }
function grm { git rm @args }

function pall () {
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	$back = Get-Location
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Output $dir.FullName
		git pull origin
	}
	Set-Location $back.Path
}

function st () {
	$originalDir = Get-Location
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Host $dir.BaseName -ForegroundColor green
		git status
	}

	Set-Location $originalDir
}
