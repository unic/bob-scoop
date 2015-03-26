<#
.SYNOPSIS
Get the current Sitecore type and version.

.DESCRIPTION
Get the current Sitecore type and version.
It returns an object with the properties "type" (Mvc or WebForms) and "version".

.PARAMETER ProjectPath
The path to the project to get the information for.

.EXAMPLE

#>
function Get-ScContextInfo
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        $packagesConfig = Join-Path $config.WebsitePath "packages.config"
        if(-not (Test-Path $packagesConfig)) {
            throw "packages.config could not be found at '$packagesConfig'"
        }

        $fs = New-Object NuGet.PhysicalFileSystem $pwd
        $packagesFile = New-Object NuGet.PackageReferenceFile $fs, $PackagesConfig

        $scTypes =  @("Mvc", "WebForms")
        $scContextInfo =
            foreach($type in $scTypes) {
                $packagesFile.GetPackageReferences() | ? {$_.Id -eq "Sitecore.$type.Config"} | % {
                    @{"type" = $type; "version" = $_.Version.ToString()}
                    break
                }
            }

        if(-not $scContextInfo) {
            $scTypePackages = $scTypes | % {"Sitecore.$_.Config"}
            Write-Error ("Could not find a Sitecore config NuGet package. You must install one in the solution in order to install Sitecore." +
            "Possible packages are: $([string]::Join(", ", $scTypes))")
        }

        $scContextInfo
    }
}
