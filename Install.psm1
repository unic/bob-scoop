Get-ChildItem -Path $PSScriptRoot\scripts\*.ps1 -Exclude "init.ps1" | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Function * -Alias *
Export-ModuleMember -Alias *