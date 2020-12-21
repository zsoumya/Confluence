function Get-CnfSpecialFolder {
    param (
        [Parameter(Mandatory)]
        [Alias('f')]
        [Environment+SpecialFolder]
        $specialFolder
    )

    return [Environment]::GetFolderPath($specialFolder)
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

function Get-CnfLocalAppDataFolder {
    return Get-CnfSpecialFolder -specialFolder LocalApplicationData
}

function Get-CnfUserProfileFolder {
    return Get-CnfSpecialFolder -specialFolder UserProfile
}

function Get-CnfProgramFilesFolder {
    return Get-CnfSpecialFolder -specialFolder ProgramFiles
}

function Test-CnfPathAlreadyPresent {
    param (
        [Parameter(Mandatory)]
        [String]
        $path,

        [Parameter(Mandatory)]
        [String]
        $newPath
    )

    $newPath = $newPath.TrimEnd('/\')
    $paths = [String[]] ($path -split ';' | ForEach-Object -Process { $_.TrimEnd('/\') })

    return $paths -contains $newPath
}

function Add-CnfPathFragment {
    param (
        [Parameter(Mandatory)]
        [String[]]
        $path,

        [switch]
        [Alias('s')]
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
    param (
        [Parameter(Mandatory)]
        [String]
        $sourcePath,

        [Parameter(Mandatory)]
        [String]
        $destinationPath,

        [String]
        $pattern = '*'
    )

    Resolve-Path -Path "$sourcePath/$pattern" | ForEach-Object -Process {
        $fileName = Split-Path -Path $_ -Leaf
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $fileName

        if (Test-Path -Path $destinationFile) {
            Write-Output -InputObject "Target exists. Deleting: $destinationFile"
            Remove-Item -Path $destinationFile -Force -ErrorAction Ignore
        }

        Write-Output -InputObject "Creating symlink: $destinationFile"
        New-Item -Type SymbolicLink -Path $destinationFile -Target $_ -Force > $null
    }
}

function Copy-CnfFolderSymLinks {
    param (
        [Parameter(Mandatory)]
        [String]
        $sourcePath,

        [Parameter(Mandatory)]
        [String]
        $destinationParent,

        [switch]
        $addToPath
    )

    $destinationName = Split-Path -Path $sourcePath -Leaf
    $destinationPath = Join-Path -Path $destinationParent -ChildPath $destinationName

    if (Test-Path -Path $destinationPath) {
        Write-Output -InputObject "Target exists. Deleting: $destinationPath"
        Remove-Item -Path $destinationPath -Force -ErrorAction Ignore
    }

    Write-Output -InputObject "Creating symlink: $(Join-Path -Path $destinationPath -ChildPath $destinationName)"
    New-Item -Type SymbolicLink -Path $destinationParent -Name $destinationName -Target $sourcePath -Force > $null

    if ($addToPath) {
        Write-Output -InputObject "Appending to PATH: $destinationPath"
        Add-CnfPathFragment -path $destinationPath -system
    }
}

function Import-CnfRegistry {
    param (
        [Parameter(Mandatory)]
        [String]
        $regFile
    )

    Write-Output -InputObject "Importing registry file: $regFile"
    & "$env:windir\regedit.exe" /S $regFile
}

function Write-CnfFileFromTemplate {
    param (
        [Parameter(Mandatory)]
        [String]
        $templateFile,

        [Parameter(Mandatory)]
        [String]
        $outputFile,

        [hashtable]
        $parameters = $null
    )

    $content = Get-Content -Path $templateFile
    
    if ($parameters) {
      $parameters.Keys | ForEach-Object -Process {
        $key = $_
        $value = $parameters[$key]

        $content = $content -replace "{{$key}}", $value
      }
    }

    Set-Content -Path $outputFile -Value $content -Force
}
