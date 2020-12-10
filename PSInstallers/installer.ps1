function Install-FromWeb {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $name,
                
        [Parameter(Mandatory=$true)]
        [string]
        $url,

        [Parameter()]
        [string]
        $pattern,

        [Parameter()]
        [string]
        $extension,

        [switch]
        $parse,
        
        [switch]
        $noProgress
    )
    
    if ($parse) {
        if (-not $PSBoundParameters.ContainsKey("pattern")) {
            throw "'pattern' must be provided if 'parse' switch is present!"
        }

        Write-Output -InputObject "Determining $name installer download link"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop 

        $url = ($response.Links | Where-Object -FilterScript { $_.href -and $_.href -match $pattern } | Select-Object -Index 0).href
        if (-not $url) {
	        throw "$name installer download link not found!"
        }
    }

    if (-not $PSBoundParameters.ContainsKey("extension")) {
        $extension = Get-ExtensionFromUrl -url $url
    }

    if (-not $extension) {
        $extension = "tmp"
    }

    $installerName = "$name-$(New-Guid).$extension"
    $installerPath = Join-Path -Path $env:TEMP -ChildPath $installerName

	if ($noProgress) {
		Write-Output -InputObject "Downloading $name installer"
    }
    
    Write-Output -InputObject "From: $url"

	if ($noProgress) {
		Write-Output -InputObject "As: $installerName"
	}

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop
    $ProgressPreference = 'Continue'

    Write-Output -InputObject "Running $name installer: $installerName"
    Start-Process -Filepath $installerPath -Wait

    Write-Output -InputObject "Deleting $name installer: $installerName"
    Remove-Item -Path $installerPath -Force
}

function Get-ExtensionFromUrl {
    param (              
        [Parameter(Mandatory=$true)]
        [System.Uri]
        $url
    )

    $pattern = '^.+\.(?<ext>.+?)$'
    if ($url.LocalPath -match $pattern) {
        return $Matches['ext']
    }
    else {
        return $null
    }
}
