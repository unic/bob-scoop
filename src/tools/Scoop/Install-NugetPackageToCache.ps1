<#

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
                -ProjectPath $ProjectPath `
                -OutputLocation $cacheLocation
        }
        
        return $cacheLocation
    }
}