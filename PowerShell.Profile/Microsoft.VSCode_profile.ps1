$profileScript = Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1

. $profileScript

# The included profile script clears the host
# For some reason the VS Code PowerShell window
# does not show the prompt after the host is
# cleared. The following statement forces the
# prompt to appear after the host is cleared.
Write-Host -Object ([string]::Empty)