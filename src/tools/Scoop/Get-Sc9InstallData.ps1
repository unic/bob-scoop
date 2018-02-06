<#
.SYNOPSIS
Installs all required packages and returns the paths required for a Sitecore 9 installation.

.DESCRIPTION
Installs the following nuget packages:
- Sitecore.Fundamentals
- Sitecore.Sif
- Sitecore.Xp0.Wdp
- Sitecore.Xp0.XConnect.Wdp
- Sitecore.Sif.Config

.EXAMPLE
Get-Sc9InstallData

#>
function Get-Sc9InstallData
{
    [CmdletBinding()]
    Param(
        [String]$ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath

        $sifInstallPath = Install-NugetPackageToCache -PackageId "Sitecore.Sif" -Version $config.SitecoreSifVersion        
        $fundamentalsInstallPath = Install-NugetPackageToCache -PackageId "Sitecore.Fundamentals" -Version $config.SitecoreFundamentalsVersion
        $sifConfigsInstallPath = Install-NugetPackageToCache -PackageId "Sitecore.Sif.Config" -Version $config.SitecoreSifConfigVersion
        $xp0WdpInstallPath = Install-NugetPackageToCache -PackageId "Sitecore.Xp0.Wdp" -Version $config.SitecoreXp0WdpVersion
        $xconnectWdpInstallPath = Install-NugetPackageToCache -PackageId "Sitecore.Xp0.XConnect.Wdp" -Version $config.SitecoreXp0ConnectWdpVersion

        return @{ `
            SifPath = $(Join-Path $sifInstallPath "SitecoreInstallFramework");
            FundamentalsPath = $(Join-Path $fundamentalsInstallPath "SitecoreFundamentals");
            SifConfigPathSitecoreXp0 = $(Join-Path $sifConfigsInstallPath "sitecore-XP0.json");
            SifConfigPathXConnectXp0 = $(Join-Path $sifConfigsInstallPath "xconnect-XP0.json");
            SifConfigPathCreateCerts = $(Join-Path $sifConfigsInstallPath "xconnect-createcert.json");
            SitecorePackagePath = $(Join-Path $xp0WdpInstallPath "xp0.scwdp.zip");
            XConnectPackagePath = $(Join-Path $xconnectWdpInstallPath "xp0xconnect.scwdp.zip");
            LicenseFilePath = $(Join-Path $(Get-ScProjectPath) $config.LicensePath)
        }
    }
}