$partentPath = (Get-Item $PSScriptRoot).Parent.FullName
Import-Module (Join-Path $partentPath common)

Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }
Export-ModuleMember -Function * -Alias *