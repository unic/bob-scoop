Get-ChildItem -Path $PSScriptRoot\modules\*.ps1 | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Function * -Alias *
Export-ModuleMember -Alias *