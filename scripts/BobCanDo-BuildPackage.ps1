$scriptInvocation = (Get-Variable MyInvocation -Scope 0).Value
$scriptPath = Split-Path $scriptInvocation.MyCommand.Definition -Parent
$modulesPath = Join-Path $scriptPath 'modules'

$outputPath = Split-Path $args[2] -Parent
New-Item -ItemType Directory -Force -Path $outputPath

Import-Module (Join-Path $modulesPath build) -Force
New-ScSerializationPackage $args[0] $args[1] $args[2]