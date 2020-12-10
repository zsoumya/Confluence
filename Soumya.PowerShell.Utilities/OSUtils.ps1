function Test-Admin {
    if ($PSVersionTable.Platform -eq 'Unix') {
        return (whoami) -eq 'root'
    }

    if ($PSVersionTable.Platform -eq 'Win32NT' -or $PSVersionTable.PSEdition -eq 'Desktop') {
        return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    }

    return $false
}