function Reset-BeyondCompare {
    & reg delete 'HKCU\Software\Scooter Software\Beyond Compare 4' /v CacheID /f
}

function Reset-Resharper {
	Write-Output -InputObject 'Resetting BeyondCompare'
	& reg delete 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{9656c84c-e0b4-4454-996d-977eabdf9e86}' /f
}

function Main {
	Write-Output -InputObject 'Resetting BeyondCompare'
    Reset-BeyondCompare
	
	Write-Output -InputObject 'Resetting Resharper'
	Reset-Resharper
}

Main
