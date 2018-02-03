<#
.SYNOPSIS
Performs all actions required on the local system to get started with a new project.
.DESCRIPTION
Configures IIS, install Sitecore, Set the serialization reference
and imports the databases to the local SQL server to enable a quick startup with a new project.

.EXAMPLE
Initialize-Environment

.EXAMPLE
bump


#>
function Initialize-Environment
{
    [CmdletBinding()]
    Param(
    )
    Process
    {
        $config = Get-ScProjectConfig
        $sitecoreMajorVersion = $config.SitecoreVersion.Substring(0, $config.SitecoreVersion.IndexOf("."))

        if($sitecoreMajorVersion -ge 9){
            $installData = Get-Sc9InstallData

            Write-Host "Installing Sitecore..."
            Install-Sitecore12 `
                -ModuleSifPath $installData.SifPath `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathSitecoreXp0 $installData.SifConfigPathSitecoreXp0 `
                -SitecorePackagePath $installData.SitecorePackagePath `
                -LicenseFilePath $installData.LicenseFilePath

            Write-Host "Installing xConnect..."
            Install-XConnect12 `
                -ModuleSifPath $installData.SifPath  `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathCreateCerts $installData.SifConfigPathCreateCerts `
                -SifConfigPathXConnectXp0 $installData.SifConfigPathXConnectXp0 `
                -XConnectPackagePath $installData.XConnectPackagePath `
                -LicenseFilePath $installData.LicenseFilePath `
                -CertPathFolder "c:\temp\certs"
            
        }
        else{
            Write-Host "Setup IIS site..."
            Enable-ScSite
            Write-Host "Install Sitecore to web-root..."
            Install-Sitecore
            Write-Host "Setup all databases..."
            Install-ScDatabases
        }
        
        Write-Host "Configure serialization reference..."
        Set-ScSerializationReference

        if(Get-Command Install-Frontend -ErrorAction SilentlyContinue) {
            if($config.BumpDisableInstallFrontend -ne 1) {
                Write-Host "Install frontend..."
                Install-Frontend
            }
        }
        if($config.BumpInstallNugetPackages -eq "1") {
            Install-ScNugetPackage
        }
        Write-Host "Build solution..."
        $sb = $dte.Solution.SolutionBuild
        $sb.Clean($true)
        $sb.Build($true)
        Write-Host "Transform all Web.config files..."
        Install-WebConfig
        Write-Host "Sync databases (Unicorn and update database)..."
        Sync-ScDatabases
    }
}

Set-Alias bump Initialize-Environment
