param($installPath, $toolsPath, $package)

$modulesPath = Join-Path $toolsPath 'modules'
Import-Module (Join-Path $modulesPath build)