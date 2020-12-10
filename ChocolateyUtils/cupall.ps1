Set-StrictMode -Version Latest

# Get the list of existing short cuts
$shortCuts1 = Get-ChildItem -Path $([System.Environment]::GetFolderPath("Desktop")) -Filter "*.lnk" | ForEach-Object -MemberName FullName

# Run chocolatey update
$cup = Get-Command -CommandType All -Name "cup"

& $cup "all"

# Get the list of existing short cuts plus new ones created by "chocolatey update"
$shortCuts2 = Get-ChildItem -Path $([System.Environment]::GetFolderPath("Desktop")) -Filter "*.lnk" | ForEach-Object -MemberName FullName

# Generate the difference which is the array of new shortcuts craeted by chocolatey update
$diff = Compare-Object -ReferenceObject $shortCuts1 -DifferenceObject $shortCuts2 -PassThru

# Delete these shortcuts
$diff | Remove-Item -Force