<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

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
                    @{"type" = $type; "version" = $_.Version}
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
