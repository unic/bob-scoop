<#
.SYNOPSIS
Initializes a Sitecore 9 base installation.

.DESCRIPTION
Uses Scratch to create a Sitecore 9 installation including xconnect

.EXAMPLE
Initialize-EnvironmentSetup

#>
function Initialize-EnvironmentSetup
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        Invoke-BobCommand {
            $installData = Get-ScInstallData $ProjectPath
        
            Write-Host "Installing xConnect..."
            Install-XConnectSetup `
                -ModuleSifPath $installData.SifPath  `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathCreateCerts $installData.SifConfigPathCreateCerts `
                -SifConfigPathXConnectXp0 $installData.SifConfigPathXConnectXp0 `
                -XConnectPackagePath $installData.XConnectPackagePath `
                -LicenseFilePath $installData.LicenseFilePath `
                -CertPathFolder $installData.CertCreationLocation

            Write-Host "Installing Sitecore..."
            Install-SitecoreSetup `
                -ModuleSifPath $installData.SifPath `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathSitecoreXp0 $installData.SifConfigPathSitecoreXp0 `
                -SitecorePackagePath $installData.SitecorePackagePath `
                -LicenseFilePath $installData.LicenseFilePath `
                -SifConfigPathCreateCerts $installData.SifConfigPathCreateCerts `
                -CertPathFolder $installData.CertCreationLocation
        }
    }
}
