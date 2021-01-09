. $PSScriptRoot\..\Helpers\ConfluenceUtils.ps1

function Reset-BeyondCompare {
    & reg delete 'HKCU\Software\Scooter Software\Beyond Compare 4' /v CacheID /f
}

function Reset-Resharper {
    & reg delete 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{9656c84c-e0b4-4454-996d-977eabdf9e86}' /f
}

function Reset-JetBrains {
    $path = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath 'JetBrains\*\eval'
    Resolve-Path -Path $path | Remove-Item -Force -Recurse
}

function Main {
  Start-Transcript -Path (Join-Path -Path $PSScriptRoot -ChildPath "swfix.log")

  Write-Output -InputObject 'Resetting BeyondCompare'
  Reset-BeyondCompare
	
  Write-Output -InputObject 'Resetting Resharper'
  Reset-Resharper
	
  Write-Output -InputObject 'Resetting JetBrains'
  Reset-JetBrains
  
  Stop-Transcript
}

Main
