<#
.SYNOPSIS
Copies model JSON to IndexWorker and XConnect instances.

.DESCRIPTION
Copies model JSON to IndexWorker and XConnect instances.

.PARAMETER ProjectPath
The project path containing the Sitecore configuration.

.EXAMPLE
Copy-XConnectModelJsonConfig

#>
function Copy-XConnectModelJsonConfig {
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process {
        function CopyFiles {
            param($source, $destination)

            if (-not (Test-Path $destination)) {
                mkdir $destination | Out-Null
            }
            
            Copy-Item $source -Destination $destination -Force
        }

        $config = Get-ScProjectConfig $ProjectPath

        if (-not $config.XConnectModels) {
            return
        }
        
        $modelsPath = Join-Path $config.WebsitePath $config.XConnectModels
        
        if ($config.IndexWorkerRoot) {
            CopyFiles $modelsPath "$($config.IndexWorkerRoot)\App_Data\Models"
        }

        if ($config.XConnectRoot) {
            CopyFiles $modelsPath  "$($config.XConnectRoot)\App_data\Models"
        }
    }
}
