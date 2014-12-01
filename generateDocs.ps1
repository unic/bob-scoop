$PSScriptRoot = split-path -parent $MyInvocation.MyCommand.Definition

$module = "Scoop"

Import-Module "$PSScriptRoot\packages\Unic.Bob.Keith\Keith"
Import-Module "$PSScriptRoot\src\tools\$module" -Force

New-PSApiDoc -ModuleName $module -Path "$PSScriptRoot\docs\"

gitbook build "$PSScriptRoot\docs\"
