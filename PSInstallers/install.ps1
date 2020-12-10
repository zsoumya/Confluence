$excluded = @("installer.ps1", $MyInvocation.MyCommand.Name, `
              "acronisdiskdirector.ps1")

Resolve-Path -Path $PSScriptRoot/*.ps1 | ForEach-Object -Process {
    $filePath = $_.Path
    $fileName = Split-Path -Path $filePath -Leaf

    if ($excluded -contains $fileName) {
        return 
    }

    & $filePath
}
