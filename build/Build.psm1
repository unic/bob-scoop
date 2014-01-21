Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude "init.ps1" | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Function * -Alias *

Set-Alias csp Create-SerializationPackage

Export-ModuleMember -Alias *