<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

#>
function Sync-ScDatabases
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        if((-not ($config.IISBindings)) -or ($config.IISBindings.Count -eq 0)) {
            Write-Error "No IIS bindings could be found."
        }
        $baseUrl = $config.IISBindings[0].InnerText
        $url = "$baseUrl/unicorn.aspx?verb=Sync"

        if(-not $config.WebRoot) {
            Write-Error "No WebRoot configured for project $($config.WebsitePath)"
        }

        $webConfig = Join-Path $config.WebRoot "Web.config"
        if(-not (Test-Path $webConfig)) {
            Write-Error "File $webConfig not found."
        }

        $webConfigDoc = New-Object System.Xml.XmlDocument
        $webConfigDoc.Load($webConfig)
        $node = $webConfigDoc.SelectSingleNode("/configuration/appSettings/add[@key='DeploymentToolAuthToken']")
        if(-not $node) {
            Write-Error "DeploymentToolAuthToken app setting could not be found in $webConfig."
        }

        $deploymentToolAuthToken = $node.Value
        Write-Verbose "Sync unicorn on $url"
        $result = Invoke-WebRequest -Uri $url -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing

        $result.Content
    }
}
