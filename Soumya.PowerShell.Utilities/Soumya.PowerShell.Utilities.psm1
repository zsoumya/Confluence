Resolve-Path $PSScriptRoot\*.ps1 | ForEach-Object -Process {
	. $_.ProviderPath
}

# Export-ModuleMember -Function Get-LineCounts
# Export-ModuleMember -Function New-OID
# Export-ModuleMember -Function Test-Admin

