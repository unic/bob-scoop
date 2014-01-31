param($installPath, $toolsPath, $package)

$modulesPath = Join-Path $toolsPath 'scripts\modules'
Import-Module (Join-Path $modulesPath build)