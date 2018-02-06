<#
.SYNOPSIS
Initializes a Sitecore 9 base installation.

.DESCRIPTION
Uses Scratch to create a Sitecore 9 installation including xconnect

.EXAMPLE
Initialize-EnvironmentSc9

#>
function Initialize-EnvironmentSc9
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        Invoke-BobCommand {
            $installData = Get-Sc9InstallData $ProjectPath
        
            Write-Host "Installing xConnect..."
            Install-XConnect12 `
                -ModuleSifPath $installData.SifPath  `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathCreateCerts $installData.SifConfigPathCreateCerts `
                -SifConfigPathXConnectXp0 $installData.SifConfigPathXConnectXp0 `
                -XConnectPackagePath $installData.XConnectPackagePath `
                -LicenseFilePath $installData.LicenseFilePath `
                -CertPathFolder $installData.CertCreationLocation

            Write-Host "Installing Sitecore..."
            Install-Sitecore12 `
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
