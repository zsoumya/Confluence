function Update-ThemeFile {
    param (              
        [Parameter(Mandatory=$true)]
        [string]
        $themeFilePath
    )

    if (-not (Test-Path -Path $themeFilePath)) {
        Write-Error -Message "Theme file does not exist!"
        return
    }

    [xml] $xml = Get-Content -Path $themeFilePath
	
	Write-Output -InputObject "Processing NotePad++ theme file: $themeFilePath"
	
	$globalOverrride = $xml.NotepadPlus.GlobalStyles.WidgetStyle | Where-Object -FilterScript { ($_.Name -eq 'Global override') -and ($_.styleID -eq 0) }
	$globalOverrride.fontName = $globalFontName
	$globalOverrride.fontSize = $globalFontSize
	
	$xml.Save($themeFilePath)
}

$globalFontName = "Cascadia Code PL"
$globalFontSize = "11"

$installDir = Join-Path -Path $env:APPDATA -ChildPath Notepad++
$themesDir = Join-Path -Path $installDir -ChildPath themes

if (-not (Test-Path -Path $themesDir)) {
	Write-Error -Message 'Notepad++ themes path not found!'
	return
}

Update-ThemeFile -themeFilePath $installDir\stylers.xml

Get-ChildItem -Path $themesDir -Filter *.xml | ForEach-Object -Process {
	$themeFile = $_.FullName
	Update-ThemeFile -themeFilePath $themeFile
}

