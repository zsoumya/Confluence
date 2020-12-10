param(
    [Parameter(Mandatory = $true)]
    [string]
    [Alias("m")]
    $commitMessage
)

git add -A

git commit -m $commitMessage

$branch = git branch --show-current

git push -u origin $branch
