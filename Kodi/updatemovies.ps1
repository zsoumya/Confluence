#!/usr/bin/env powershell
param (
  [Parameter(Mandatory, HelpMessage='Root folder of the movie library')]
  [ValidateScript({ $_.Exists }, ErrorMessage = 'Folder ''{0}'' does not exist.')]
  [IO.DirectoryInfo]
  $rootFolder,

  [Switch]
  $confirm,

  [string]
  $pattern = $null
)

$movieFilePattern = '^.+\.(mp4|mkv|avi|wmv|webm|mov)$'
$artWorkTypes = ('banner', 'clearart', 'clearlogo', 'disc', 'fanart', 'keyart', 'logo', 'poster', 'thumb')

function Test-FileExists {
  param (
    [Parameter(Mandatory, HelpMessage='File to test')]
    [IO.FileInfo]
    $path
  )

  return $path.Exists
}

function Update-Subtitle {
  param (
    [Parameter(Mandatory, HelpMessage='Working folder')]
    [ValidateScript({ $_.Exists }, ErrorMessage = 'Folder ''{0}'' does not exist.')]
    [IO.DirectoryInfo]
    $folder,

    [Parameter(Mandatory, HelpMessage='Base file name')]
    [string]
    $baseFileName,

    [Switch]
    $confirm
  )

  $path = (Join-Path -Path $folder.FullName -ChildPath '*.srt').Replace('[', '`[').Replace(']', '`]')

  $subtitleFile = Resolve-Path -Path $path
  $subtitleCount = ($subtitleFile | Measure-Object).Count

  if ($subtitleCount -eq 1 -and $subtitleFile.Path.EndsWith('.eng.srt')) {
    $oldName = Split-Path -Path $subtitleFile.Path -Leaf
    $newName = "$baseFileName.srt"

    if ($confirm) {
      Write-Output -InputObject "$oldName -> $newName (Rename)"
      Rename-Item -Path $subtitleFile.Path -NewName "$baseFileName.srt"
    }
    else {
      Write-Output -InputObject "$oldName -> $newName (Rename) [NOP]"
    }
  }
  else {
    Write-Verbose -Message 'No subtitle file name change needed'
  }
}

function Update-Info {
  param (
    [Parameter(Mandatory, HelpMessage='Working folder')]
    [ValidateScript({ $_.Exists }, ErrorMessage = 'Folder ''{0}'' does not exist.')]
    [IO.DirectoryInfo]
    $folder,

    [Parameter(Mandatory, HelpMessage='Base file name')]
    [string]
    $baseFileName,

    [Switch]
    $confirm
  )

  $unqualifiedName = 'movie.nfo'
  $unqualifiedPathName = Join-Path -Path $folder.FullName -ChildPath $unqualifiedName

  $qualifiedName = "$baseFileName.nfo"
  $qualifiedPathName = Join-Path -Path $folder.FullName -ChildPath $qualifiedName

  if (-not (Test-FileExists -Path $unqualifiedPathName)) {
    Write-Output -InputObject "$unqualifiedName -> Not found"
    return
  }

  Write-Verbose -Message "Unqualified Name: $unqualifiedName"
  Write-Verbose -Message "Unqualified Path Name: $unqualifiedPathName"

  Write-Verbose -Message "Qualified Name: $qualifiedName"
  Write-Verbose -Message "Qualified Path Name: $qualifiedPathName"

  if (Test-FileExists -Path $qualifiedPathName) {
    if ($confirm) {
      Write-Output -InputObject "$unqualifiedName -> Deleted ($qualifiedName exists)"
      Remove-Item -Path $unqualifiedPathName -Force
    }
    else {
      Write-Output -InputObject "$unqualifiedName -> Deleted ($qualifiedName exists) [NOP]"
    }
  }
  else {
    if ($confirm) {
      Write-Output -InputObject "$unqualifiedName -> $qualifiedName (Rename)"
      Rename-Item -Path $unqualifiedPathName -NewName $qualifiedName
    }
    else {
      Write-Output -InputObject "$unqualifiedName -> $qualifiedName (Rename) [NOP]"
    }
  }
}

function Update-ArtWork {
  param (
    [Parameter(Mandatory, HelpMessage='Working folder')]
    [ValidateScript({ $_.Exists }, ErrorMessage = 'Folder ''{0}'' does not exist.')]
    [IO.DirectoryInfo]
    $folder,

    [Parameter(Mandatory, HelpMessage='Base file name')]
    [string]
    $baseFileName,

    [Switch]
    $confirm
  )

  foreach ($artWorkType in $artWorkTypes) {
    Write-Verbose -Message "Processing artwork type: $artWorkType"

    $path = (Join-Path -Path $folder.FullName -ChildPath "$artWorkType.*").Replace('[', '`[').Replace(']', '`]')

    Resolve-Path -Path $path | ForEach-Object {

      $extension = [IO.Path]::GetExtension($_.Path)

      $unqualifiedName = [IO.Path]::GetFileName($_.Path)
      $unqualifiedPathName = $_.Path

      $qualifiedName = "$baseFileName-$artWorkType$extension"
      $qualifiedPathName = Join-Path -Path $folder.FullName -ChildPath $qualifiedName

      Write-Verbose -Message "Unqualified Name: $unqualifiedName"
      Write-Verbose -Message "Unqualified Path Name: $unqualifiedPathName"

      Write-Verbose -Message "Qualified Name: $qualifiedName"
      Write-Verbose -Message "Qualified Path Name: $qualifiedPathName"

      if (Test-FileExists -Path $qualifiedPathName) {
        if ($confirm) {
          Write-Output -InputObject "$unqualifiedName -> Deleted ($qualifiedName exists)"
          Remove-Item -Path $unqualifiedPathName -Force
        }
        else {
          Write-Output -InputObject "$unqualifiedName -> Deleted ($qualifiedName exists) [NOP]"
        }
      }
      else {
        if ($confirm) {
          Write-Output -InputObject "$unqualifiedName -> $qualifiedName (Rename)"
          Rename-Item -Path $unqualifiedPathName -NewName $qualifiedName
        }
        else {
          Write-Output -InputObject "$unqualifiedName -> $qualifiedName (Rename) [NOP]"
        }
      }
    }
  }
}

function Update-Movie {
  param (
    [Parameter(Mandatory, HelpMessage='Folder of the movie library')]
    [ValidateScript({ $_.Exists }, ErrorMessage = 'Folder ''{0}'' does not exist.')]
    [IO.DirectoryInfo]
    $folder,

    [string]
    $pattern = $null,

    [Switch]
    $confirm,

    [switch]
    $root
  )

  $folderName = $folder.BaseName

  if ($root -or [string]::IsNullOrWhiteSpace($pattern) -or $folderName -imatch $pattern)
  {
    Write-Output -InputObject "Processing: $folder"
  }
  else {
    Write-Verbose -Message "Skipping: $folder"
    return
  }

  Write-Output -InputObject "-------------------------------------------------------"

  $childFolders = $folder.GetDirectories()
  $movieFile = $folder.GetFiles() | Where-Object -FilterScript { $_.Name -imatch $movieFilePattern }
  $movieFilesCount = ($movieFile | Measure-Object).Count

  if ($movieFilesCount -gt 1) {
    Write-Warning -Message 'Multiple movie files found'
  }

  if ($movieFilesCount -eq 0) {
    Write-Verbose -Message 'No movie files found'
  }

  if ($movieFilesCount -eq 1) {
    $movieFileName = $movieFile.Name
    $baseName = [IO.Path]::GetFileNameWithoutExtension($movieFileName)

    Write-Output -InputObject "Movie File: $($movieFile.Name)"

    Write-Verbose -Message 'Updating artwork'
    Update-ArtWork -folder $folder -baseFileName $baseName -confirm:$confirm

    Write-Verbose -Message 'Updating NFO'
    Update-Info -folder $folder -baseFileName $baseName -confirm:$confirm

    Write-Verbose -Message 'Updating subtitle'
    Update-Subtitle -folder $folder -baseFileName $baseName -confirm:$confirm

    $Script:movieCount++
  }

  Write-Output -InputObject "-------------------------------------------------------"

  foreach ($childFolder in $childFolders) {
    Update-Movie -folder $childFolder -confirm:$confirm -pattern $pattern
  }
}

Start-Transcript -Path (Join-Path -Path $rootFolder -ChildPath 'LibraryUpdateLog.txt')

$stopWatch = [Diagnostics.Stopwatch]::StartNew()

Write-Output -InputObject "Root folder: $rootFolder"

if (-not ([string]::IsNullOrWhiteSpace($pattern)))
{
  Write-Output -InputObject "Pattern: $pattern"
}
else {
  Write-Verbose -Message 'Pattern: -None-'
}

Write-Output -InputObject "Confirm: $confirm"

$movieCount = 0

Update-Movie -folder $rootFolder -confirm:$confirm -pattern $pattern -root

Write-Output -InputObject "Total movies processed: $movieCount"

$stopWatch.Stop()

Write-Output -InputObject ('Total time taken: {0:0.00}' -f $stopWatch.Elapsed.TotalSeconds)

Stop-Transcript