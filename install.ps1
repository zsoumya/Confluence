. .\Helpers\ConfluenceUtils.ps1

# -- 7-Zip -- #
function Install-Cnf7ZipSettings {
    $regFile = Join-Path -Path $PSScriptRoot -ChildPath "7-Zip\7zipsettings.reg"

    Write-Output -InputObject "Installing 7-Zip Settings"
    Write-Output -InputObject "Importing Reg file: $regFile"
    Import-CnfRegistry -regFile $regFile
}

# -- Beyond Compare -- #
function Install-CnfBeyondCompareSettings {
    $pathFragment = Join-Path -Path (Get-CnfProgramFilesFolder) -ChildPath "Beyond Compare 4"
    $settingsFile = Join-Path -Path $PSScriptRoot -ChildPath "BeyondCompare\BCSettings.bcpkg"

    Write-Output -InputObject "Adding Beyond Compare to Path"
    Write-Output -InputObject "Path fragment: $pathFragment"
    Add-CnfPathFragment -path $pathFragment -system

    Write-Output -InputObject "Importing Beyond Compare Settings"
    Write-Output -InputObject "Settings file: $settingsFile"
    Start-Process -FilePath $settingsFile -Wait
}

# -- ChocolateyUtils -- #
function Install-CnfChocolateyUtils {
    $leafPath = "ChocolateyUtils"
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath $leafPath
    $destinationParent = "C:\tools"

    Write-Output -InputObject "Installing Chocolatey Utils"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $(Join-Path -Path $destinationParent -ChildPath $leafPath)"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- ConEmu -- #
function Install-CnfConEmuSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "ConEmu"
    $destinationPath = Get-CnfAppDataFolder

    Write-Output -InputObject "Installing ConEmu Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "ConEmu.xml"
}

# -- EditPlus -- #
function Install-CnfEditPlusSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "EditPlus"
    $destinationPath = Join-Path -Path (Get-CnfProgramFilesFolder) -ChildPath EditPlus

    Write-Output -InputObject "Installing EditPlus Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "editplus_u.ini"
}

# -- Everything -- #
function Install-CnfEverythingSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "Everything"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath Everything

    Write-Output -InputObject "Installing Everything Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "Everything.ini"
}

# -- GitConfig -- #
function Install-CnfGitConfig {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "GitConfig"
    $destinationPath = Get-CnfUserProfileFolder

    Write-Output -InputObject "Installing GitConfig"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern ".git*"
}

# -- GitTools -- #
function Install-CnfGitTools {
    $leafPath = "GitTools"
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath $leafPath
    $destinationParent = "C:\tools"

    Write-Output -InputObject "Installing Git Tools"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $(Join-Path -Path $destinationParent -ChildPath $leafPath)"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- Notepad++ -- #
function Install-CnfNotepadPlusPlusGlobalFonts {
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "Notepad++\notepad++globalfont.ps1"

    Write-Output -InputObject "Configuring Notepad++ Global Fonts"
    Write-Output -InputObject "Invoking: $scriptPath"
    & $scriptPath
}

# -- Notepad3 -- #
function Install-CnfNotepad3Settings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "Notepad3"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath "Rizonesoft\Notepad3"

    Write-Output -InputObject "Installing Notepad3 Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.ini"

    $templateFile = Join-Path -Path $sourcePath -ChildPath "notepad-replacement.reg.template"
    $outputFile = Join-Path -Path $sourcePath -ChildPath "notepad-replacement.reg"
    $parameters = @{ ProgramPath = (Join-Path -Path (Get-CnfProgramFilesFolder) -ChildPath "Notepad3\Notepad3.exe") -replace "\\", "\\" }

    Write-Output -InputObject "Generating Reg file from template"
    Write-Output -InputObject "Template file: $templateFile"
    Write-CnfFileFromTemplate -templateFile $templateFile -outputFile $outputFile -parameters $parameters

    Write-Output -InputObject "Setting Notepad3 as replacement of Notepad"
    Write-Output -InputObject "Importing Reg file: $outputFile"
    Import-CnfRegistry -regFile $outputFile
}

# -- Oh-My-Posh Themes -- #
function Install-CnfOhMyPoshThemes {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "OhMyPoshThemes"
    $destinationPath = Join-Path -Path (Get-CnfDocumentsFolder) -ChildPath "PowerShell\modules\oh-my-posh\*\themes"
    $destinationPath = (Resolve-Path -Path $destinationPath)[0].Path

    Write-Output -InputObject "Installing Oh-My-Posh Themes"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.json"
}

# -- Path-Copy-Copy -- #
function Install-CnfPathCopyCopySettings {
    $regFile = Join-Path -Path $PSScriptRoot -ChildPath "PathCopyCopy\path-copy-copy-settings.reg"

    Write-Output -InputObject "Installing Path-Copy-Copy Settings"
    Write-Output -InputObject "Importing Reg file: $regFile"
    Import-CnfRegistry -regFile $regFile
}

# -- PowerShell Profile -- #
function Install-CnfPowerShellProfile {
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Desktop', 'Core')]
        [string]
        $edition
    )
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "PowerShellCore.Profile"
    $destinationPath = "PowerShell"

    if ($edition -ieq 'Desktop') {
        $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "PowerShell.Profile"
        $destinationPath = "WindowsPowerShell"
    }
    $destinationPath = Join-Path -Path (Get-CnfDocumentsFolder) -ChildPath $destinationPath

    Write-Output -InputObject "Installing PowerShell $(if ($edition -ieq "Core") { "Core" }) Profile"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.ps1"
}

# -- ProcessHacker Settings -- #
function Install-CnfProcessHackerSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "ProcessHacker"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath "Process Hacker 2"

    Write-Output -InputObject "Installing ProcessHacker Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.xml"
}

# -- Scripts -- #
function Install-CnfScripts {
    $leafPath = "Scripts"
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath $leafPath
    $destinationParent = "C:\tools"

    Write-Output -InputObject "Installing Scripts"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $(Join-Path -Path $destinationParent -ChildPath $leafPath)"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- VS Code -- #
function Install-CnfVSCodeSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "VSCodeSettings"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath "Code\User"

    Write-Output -InputObject "Installing VSCode Settings Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.json"
}

# -- Windows Settings -- #
function Install-CnfWindowsSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "Windows\*.reg"
    Write-Output -InputObject "Installing Windows Settings"

    Resolve-Path -Path $sourcePath | ForEach-Object -Process {
        $regFile = $_.Path

        Write-Output -InputObject "Importing Reg file: $regFile"
        Import-CnfRegistry -regFile $regFile
    }
}

# -- Windows Terminal Settings -- #
function Install-CnfWindowsTerminalSettings {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "WindowsTerminal"
    $destinationPath = Join-Path -Path (Get-CnfLocalAppDataFolder) -ChildPath "Packages\Microsoft.WindowsTerminal*\LocalState"
    $destinationPath = (Resolve-Path -Path $destinationPath)[0].Path

    Write-Output -InputObject "Installing Windows Terminal Settings"
    Write-Output -InputObject "Source path: $sourcePath"
    Write-Output -InputObject "Destination path: $destinationPath"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "settings.json"
}

if ((Resolve-Path -Path $MyInvocation.InvocationName)[0].Path -ceq $PSCommandPath) {
    Install-Cnf7ZipSettings
    Write-Output -InputObject ""

    Install-CnfBeyondCompareSettings
    Write-Output -InputObject ""

    Install-CnfChocolateyUtils
    Write-Output -InputObject ""

    Install-CnfConEmuSettings
    Write-Output -InputObject ""

    Install-CnfEditPlusSettings
    Write-Output -InputObject ""

    Install-CnfEverythingSettings
    Write-Output -InputObject ""

    Install-CnfGitConfig
    Write-Output -InputObject ""

    Install-CnfGitTools
    Write-Output -InputObject ""

    Install-CnfNotepadPlusPlusGlobalFonts
    Write-Output -InputObject ""

    Install-CnfNotepad3Settings
    Write-Output -InputObject ""

    Install-CnfOhMyPoshThemes
    Write-Output -InputObject ""

    Install-CnfPathCopyCopySettings
    Write-Output -InputObject ""

    Install-CnfPowerShellProfile -edition Desktop
    Write-Output -InputObject ""

    Install-CnfPowerShellProfile -edition Core
    Write-Output -InputObject ""

    Install-CnfProcessHackerSettings
    Write-Output -InputObject ""

    Install-CnfScripts
    Write-Output -InputObject ""

    Install-CnfVSCodeSettings
    Write-Output -InputObject ""

    Install-CnfWindowsSettings
    Write-Output -InputObject ""

    Install-CnfWindowsTerminalSettings
    Write-Output -InputObject ""
}