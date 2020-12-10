$webExProcesses = @("ptoneclk", "WebexMTA", "ciscowebexstart")

$webExProcesses | ForEach-Object -Process {
    Get-Process -Name $_ -ErrorAction Ignore | Stop-Process -Force -ErrorAction Ignore
}