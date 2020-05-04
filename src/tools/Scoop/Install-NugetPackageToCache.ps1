<#
.SYNOPSIS
Installs a NuGet package to the Bob-Cache.

.DESCRIPTION
Installs the specified NuGet package to "${env:AppData}\Bob\$PackageId 
if it's not yet installed there.

.PARAMETER PackageId
The NuGet package id.

.PARAMETER Version
The version of the package to install.

.PARAMETER ProjectPath
The path to the project.

.EXAMPLE
Install-NugetPackageToCache  -PackageId Unic.Test -Version 3.2

#>
function Install-NugetPackageToCache 
{
    [CmdletBinding()]
    Param(
        $PackageId,
        $Version, 
        $ProjectPath
    )
    Process
    {
        $cacheLocation = "${env:AppData}\Bob\$PackageId"
        if(-not (Test-Path $cacheLocation)) {
            mkdir $cacheLocation | Out-Null
        }

        $cacheLocation = "$cacheLocation\$Version"

        if(-not (Test-Path $cacheLocation)) {
            Install-NugetPackage `
                -PackageId $PackageId `
                -Version $Version `
                -OutputLocation $cacheLocation | Out-Null
        }
        
        return $cacheLocation
    }
}
