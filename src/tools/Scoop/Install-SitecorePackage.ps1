<#
.SYNOPSIS
Installs the correct Sitecore distribution to a specific location.
.DESCRIPTION
Install-SitecorePackage installs the  correct Sitecore distribution to a specific location.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website proje

.PARAMETER OutputLocation
The location where to extract the Sitecore distribution

.EXAMPLE
Install-SitecorePackage -OutputLocation D:\Web\Magic

#>
function Install-SitecorePackage
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $OutputLocation,
        [Parameter(Mandatory=$true)]
        [string] $PackagesConfig,
        [Parameter(Mandatory=$true)]
        [string] $Source
    )
    Process
    {
        $fs = New-Object NuGet.PhysicalFileSystem $pwd
        $setting = [NuGet.Settings]::LoadDefaultSettings($fs,  [System.Environment]::GetFolderPath("ApplicationData") + "\NuGet\NuGet.config", $null);
        $sourceProvider = New-Object NuGet.PackageSourceProvider $setting

        $credentialProvider = New-Object NuGet.SettingsCredentialProvider -ArgumentList ([NuGet.ICredentialProvider][NuGet.NullCredentialProvider]::Instance), ([NuGet.IPackageSourceProvider]$sourceProvider)

        [NuGet.HttpClient]::DefaultCredentialProvider = $credentialProvider


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

        $repo = New-Object  NuGet.DataServicePackageRepository $Source

        $packageId = "Sitecore.Distribution." + $scContextInfo.type
        $version = $scContextInfo.version
        Write-Verbose "Install $packageId $version"
        $packageToInstall = $repo.FindPackagesById($packageId) | ? {$_.Version -eq $version.ToString()}

        $outputFileSystem = New-Object NuGet.PhysicalFileSystem $OutputLocation
        #$package.GetFiles().Path | % {"$Location\$_"} | ? {Test-Path $_} | % {rm $_}
        $outputFileSystem.AddFiles($packageToInstall.GetFiles(), $OutputLocation)

        return
        $packageManager = New-Object $nugetCore.GetType("NuGet.PackageManager") ($repository, $pathResolver, $packagesFolderFileSystem, $localRepository)
        $installed = $false
        $types = @("Mvc", "WebForms")
        $i = 0
        while((-not $installed) -and ($i -lt $types.Length)) {
            $type = $types[$i]
            $package = Get-Package -Filter "Sitecore.$type.Config"
            if($package) {
                Write-Verbose "Install Sitecore.Distribution.$type $($package.Version)"
                $packageManager.InstallPackage("Sitecore.Distribution.$type", $($package.Version) )
                $installed = $true
            }
            $i++;
        }
    }
}
