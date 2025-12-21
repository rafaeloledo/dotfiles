reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchbarAllowed" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1694661260" /v "EnabledState" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\8\1694661260" /v "EnabledStateOptions" /t REG_DWORD /d 0 /f
