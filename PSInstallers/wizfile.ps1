. $PSScriptRoot\installer.ps1

Install-FromWeb -name WizFile -url "https://antibody-software.com/wizfile/download" -pattern "wizfile.+setup\.exe$" -parse

