. .\Helpers\conf-utils.ps1
# -- 7-Zip -- #
function Install-Cnf7ZipSettings {
    Write-Output -InputObject "Installing 7-Zip Settings"
    Import-CnfRegistry -regFile ".\7-Zip\7zipsettings.reg"
}

# -- Beyond Compare -- #
function Install-CnfBeyondCompareSettings {
    Write-Output -InputObject "Installing Beyond Compare Settings"
    Start-Process -FilePath ".\BeyondCompare\BCSettings.bcpkg" -Wait
}

# -- ChocolateyUtils -- #
function Install-CnfChocolateyUtils {
    $sourcePath = ".\ChocolateyUtils\"
    $destinationParent = "C:\tools"
    Write-Output -InputObject "Installing Chocolatey Utils"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- ConEmu -- #
function Install-CnfConEmuSettings {
    $sourcePath = ".\ConEmu\"
    $destinationPath = Get-CnfAppDataFolder
    Write-Output -InputObject "Installing ConEmu Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "ConEmu.xml"
}

# -- EditPlus -- #
function Install-CnfEditPlusSettings {
    $sourcePath = ".\EditPlus\"
    $destinationPath = Join-Path -Path (Get-CnfProgramFilesFolder) -ChildPath EditPlus
    Write-Output -InputObject "Installing EditPlus Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "editplus_u.ini"
}

# -- Everything -- #
function Install-CnfEverythingSettings {
    $sourcePath = ".\Everything\"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath Everything
    Write-Output -InputObject "Installing Everything Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "Everything.ini"
}

# -- GitConfig -- #
function Install-CnfGitConfig {
    $sourcePath = ".\GitConfig\"
    $destinationPath = Get-CnfUserProfileFolder
    Write-Output -InputObject "Installing GitConfig"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern ".git*"
}

# -- GitTools -- #
function Install-CnfGitTools {
    $sourcePath = ".\GitTools\"
    $destinationParent = "C:\tools"
    Write-Output -InputObject "Installing Git Tools"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- Notepad++ -- #
function Install-CnfNotepadPlusPlusGlobalFonts {
    Write-Output -InputObject "Configuring Notepad++ Global Fonts"
    & ".\Notepad++\notepad++globalfont.ps1"
}

# -- Notepad3 -- #
function Install-CnfNotepad3Settings {
    $sourcePath = ".\Notepad3\"
    $destinationPath = Join-Path -Path (Get-CnfAppDataFolder) -ChildPath "Rizonesoft\Notepad3"
    Write-Output -InputObject "Installing Notepad3 Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.ini"
    $templateFile = Join-Path -Path $sourcePath -ChildPath "notepad-replacement.reg.template"
    $outputFile = Join-Path -Path $sourcePath -ChildPath "notepad-replacement.reg"
    $parameters = @{ ProgramPath = (Join-Path -Path (Get-CnfProgramFilesFolder) -ChildPath "Notepad3\Notepad3.exe") -replace "\\", "\\" }
    Write-Output -InputObject "Generating registry file from template"
    Write-CnfFileFromTemplate -templateFile $templateFile -outputFile $outputFile -parameters $parameters
    Write-Output -InputObject "Setting Notepad3 as replacement of Notepad"
    Import-CnfRegistry -regFile $outputFile
}

# -- Oh-My-Posh Themes -- #
function Install-CnfOhMyPoshThemes {
    $sourcePath = ".\OhMyPoshThemes\"
    $destinationPath = Join-Path -Path (Get-CnfDocumentsFolder) -ChildPath "PowerShell\modules\oh-my-posh\*\themes"
    $destinationPath = (Resolve-Path -Path $destinationPath)[0].Path
    
    Write-Output -InputObject "Installing Oh-My-Posh Themes"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.json"
}

# -- Path-Copy-Copy -- #
function Install-CnfPathCopyCopySettings {
    Write-Output -InputObject "Installing Path-Copy-Copy Settings"
    Import-CnfRegistry -regFile ".\PathCopyCopy\path-copy-copy-settings.reg"
}

# -- PowerShell Profile -- #
function Install-CnfPowerShellProfile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Desktop', 'Core')]
        [string]
        $edition
    )
    $sourcePath = ".\PowerShellCore.Profile\"
    $destinationPath = "PowerShell"
    
    if ($edition -ieq 'Desktop') {
        $sourcePath = ".\PowerShell.Profile\"
        $destinationPath = "WindowsPowerShell"
    }
    $destinationPath = Join-Path -Path (Get-CnfDocumentsFolder) -ChildPath $destinationPath
    Write-Output -InputObject "Installing PowerShell $(if ($edition -ieq "Core") { "Core" }) Profile"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.ps1"
}

# -- ProcessHacker Settings -- #
function Install-CnfProcessHackerSettings {
    $sourcePath = ".\ProcessHacker\"
    $destinationPath = Join-Path -Path (CnfAppDataFolder) -ChildPath "Process Hacker 2"
    
    Write-Output -InputObject "Installing ProcessHacker Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.xml"
}

# -- Scripts -- #
function Install-CnfScripts {
    $sourcePath = ".\Scripts\"
    $destinationParent = "C:\tools"
    Write-Output -InputObject "Installing Scripts"
    Copy-CnfFolderSymLinks -sourcePath $sourcePath -destinationParent $destinationParent -addToPath
}

# -- VS Code -- #
function Install-CnfVSCodeSettings {
    $sourcePath = ".\VSCodeSettings\"
    $destinationPath = Join-Path -Path (CnfAppDataFolder) -ChildPath "Code\User"
    
    Write-Output -InputObject "Installing VSCode Settings Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "*.json"
}

# -- Windows Settings -- #
function Install-CnfWindowsSettings {
    $sourcePath = ".\Windows\*.reg"
    Write-Output -InputObject "Installing Windows Settings"
    Resolve-Path -Path $sourcePath | ForEach-Object -Process {
        Import-CnfRegistry -regFile $_.Path
    }
}

# -- Windows Terminal Settings -- #
function Install-CnfWindowsTerminalSettings {
    $sourcePath = ".\WindowsTerminal\"
    $destinationPath = (Resolve-Path -Path "C:\Users\Soumya\AppData\Local\Packages\Microsoft.WindowsTerminal*\LocalState")[0].Path
    Write-Output -InputObject "Installing Windows Terminal Settings"
    Copy-CnfFileSymLinks -sourcePath $sourcePath -destinationPath $destinationPath -pattern "settings.json"
}

Install-Cnf7ZipSettings
Install-CnfBeyondCompareSettings
Install-CnfChocolateyUtils
Install-CnfConEmuSettings
Install-CnfEditPlusSettings
Install-CnfEverythingSettings
Install-CnfGitConfig
Install-CnfGitTools
Install-CnfNotepadPlusPlusGlobalFonts
Install-CnfNotepad3Settings
Install-CnfOhMyPoshThemes
Install-CnfPathCopyCopySettings
Install-CnfPowerShellProfile -edition Desktop
Install-CnfPowerShellProfile -edition Core
Install-CnfProcessHackerSettings 
Install-CnfScripts
Install-CnfVSCodeSettings
Install-CnfWindowsSettings 
Install-CnfWindowsTerminalSettings

