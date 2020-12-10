function Get-CnfSpecialFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Alias("f")]
        [System.Environment+SpecialFolder]
        $specialFolder
    )

    return [System.Environment]::GetFolderPath($specialFolder)
}

function Get-CnfDesktopFolder {
    return Get-CnfSpecialFolder -specialFolder Desktop
}

function Get-CnfDocumentsFolder {
    return Get-CnfSpecialFolder -specialFolder MyDocuments
}

function Get-CnfAppDataFolder {
    return Get-CnfSpecialFolder -specialFolder ApplicationData
}

function Get-CnfUserProfileFolder {
    return Get-CnfSpecialFolder -specialFolder UserProfile
}

function Get-CnfProgramFilesFolder {
    return Get-CnfSpecialFolder -specialFolder ProgramFiles
}

function Test-CnfPathAlreadyPresent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $path,

        [Parameter(Mandatory=$true)]
        [String]
        $newPath
    )

    $newPath = $newPath.TrimEnd("/\")
    $paths = [String[]] ($path -split ";" | ForEach-Object -Process { $_.TrimEnd("/\") })

    return $paths -contains $newPath
}

function Append-CnfPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String[]]
        $path,

        [switch]
        [Alias("s")]
        $system
    )

    $registryKey = 'Registry::HKEY_CURRENT_USER\Environment'

    if ($system) {
        $registryKey = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
    }

    $currentPath = (Get-ItemProperty -Path $registryKey -Name PATH).Path

    foreach ($eachPath in $path) {
        if (-not (Test-Path -Path $eachPath)) {
            throw "Path does not exist: $eachPath"
        }
        
        if (-not (Test-CnfPathAlreadyPresent -path $currentPath -newPath $eachPath)) {
            $currentPath = "$currentPath;$eachPath"
        }
    }

    Set-ItemProperty -Path $registryKey -Name Path -Value $currentPath
}

function Copy-CnfFileSymLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $sourcePath,

        [Parameter(Mandatory=$true)]
        [String]
        $destinationPath,

        [Parameter()]
        [String]
        $pattern = "*"
    )

    Resolve-Path -Path "$sourcePath/$pattern" | ForEach-Object -Process {
        $fileName = Split-Path -Path $_ -Leaf
        $backupFilename = "$fileName.bak"
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $fileName

        if (Test-Path -Path $destinationFile) {
            Write-Output -InputObject "$destinationFile exists. Backing up."
            Remove-Item -Path (Join-Path -Path $destinationPath -ChildPath $backupFilename) -Force -ErrorAction Ignore
            Rename-Item -Path $destinationFile -NewName $backupFilename -Force
        }

        Write-Output -InputObject "Creating symlink: $destinationFile"
        New-Item -Type SymbolicLink -Path $destinationFile -Target $_ -Force > $null
    }
}

function Copy-CnfFolderSymLinks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $sourcePath,

        [Parameter(Mandatory=$true)]
        [String]
        $destinationParent,

        [Parameter()]
        [switch]
        $addToPath
    )

    $destinationName = Split-Path -Path $sourcePath -Leaf
    $destinationPath = Join-Path -Path $destinationParent -ChildPath $destinationName

    Write-Output -InputObject "Creating symlink: $(Join-Path -Path $destinationPath -ChildPath $destinationName)"
    New-Item -Type SymbolicLink -Path $destinationParent -Name $destinationName -Target $sourcePath -Force > $null

    if ($addToPath) {
        Write-Output -InputObject "Appending to PATH: $destinationPath"
        Append-CnfPath -path $destinationPath -system
    }
}

function Import-CnfRegistry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $regFile
    )

    Write-Output -InputObject "Importing registry file: $regFile"
    regedit /S $regFile
}

function Write-CnfFileFromTemplate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $templateFile,

        [Parameter(Mandatory=$true)]
        [String]
        $outputFile,

        [Parameter()]
        [hashtable]
        $parameters
    )

    $content = Get-Content -Path $templateFile

    $parameters.Keys | ForEach-Object -Process {
        $key = $_
        $value = $parameters[$key]

        $content = $content -replace "{{$key}}", $value
    }

    Set-Content -Path $outputFile -Value $content -Force
}