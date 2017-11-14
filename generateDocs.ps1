$PSScriptRoot = split-path -parent $MyInvocation.MyCommand.Definition

$module = "Scoop"

Import-Module "$PSScriptRoot\packages\Unic.Bob.Keith\Keith"
Import-Module "$PSScriptRoot\src\tools\$module" -Force

New-PsDoc -Module $module -Path "$PSScriptRoot\docs\" -OutputLocation "$PSScriptRoot\docs-generated"

New-GitBook "$PSScriptRoot\docs-generated" "$PSScriptRoot\temp"
