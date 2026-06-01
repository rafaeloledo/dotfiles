$WarningPreference = "SilentlyContinue"

Import-Module PsFzfUtil
#Import-Module PSFzf

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
