<#
.SYNOPSIS
Installs the correct Sitecore distribution to a specific location.
.DESCRIPTION
Install-SitecorePackage installs the  correct Sitecore distribution to a specific location.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website proje

.PARAMETER OutputLocation
The location where to extract the Sitecore distribution

.PARAMETER ProjectPath
The project path containing the Sitecore configuration.

.EXAMPLE
Install-SitecorePackage -OutputLocation D:\Web\Magic

#>
function Install-SitecorePackage
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $OutputLocation,
        [string] $ProjectPath
    )
    Process
    {
        $scContextInfo = Get-ScContextInfo $ProjectPath
        $packageId = "Sitecore.Distribution." + $scContextInfo.type
        Install-NugetPackage -PackageId $packageId -Version $scContextInfo.version -OutputLocation $OutputLocation
    }
}
