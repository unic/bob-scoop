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
        if((Get-ScMajorVersion) -ge 9){
            Initialize-EnvironmentSc9
        }
        else{
            Write-Host "Setup IIS site..."
            Enable-ScSite
            Write-Host "Install Sitecore to web-root..."
            Install-Sitecore
        }

        Write-Host "Setup all databases..."
        Install-ScDatabases
        
        Write-Host "Configure serialization reference..."
        Set-ScSerializationReference

        $config = Get-ScProjectConfig

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

        Stop-ScAppPool
        $sb = $dte.Solution.SolutionBuild        
        $sb.Clean($true)
        $sb.Build($true)
        Start-ScAppPool

        Write-Host "Transform all Web.config files..."
        Install-WebConfig

        Write-Host "Sync databases (Unicorn and update database)..."
        Sync-ScDatabases
    }
}

Set-Alias bump Initialize-Environment
