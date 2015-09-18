<#
.SYNOPSIS
Deserialize all items to the database.

.DESCRIPTION
Deserialize all items from a repository to the database.
This includes:
- Perform unicorn sync for application and test data
- Perform an update database for the default items

.PARAMETER ProjectPath
The path to the project for which the items should be installed.

.EXAMPLE
Sync-ScDatabases

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


        $disableIndexingUrl =  "$baseUrl/bob/disableIndexing"
        Write-Verbose "Disable indexing on $disableIndexingUrl"
        $result =  Invoke-WebRequest -Uri $disableIndexingUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
        $result.Content

        $unicornUrl = "$baseUrl/unicorn.aspx?verb=Sync"
        Write-Verbose "Sync unicorn on $unicornUrl"
        $result = Invoke-WebRequest -Uri $unicornUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
        $result.Content

        $updateDbUrl = "$baseUrl/bob/updateDatabase"
        Write-Verbose "Update database for default items $updateDbUrl"
        $result = Invoke-WebRequest -Uri $updateDbUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
        $result.Content


        $reEnableIndexUrl =  "$baseUrl/bob/reEnableIndexing"
        Write-Verbose "Re-enable indexing on $reEnableIndexUrl"
        $result =  Invoke-WebRequest -Uri $reEnableIndexUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
        $result.Content

        $fullPublishUrl = "$baseUrl/bob/fullPublish"
        Write-Verbose "Do full publish with URL $fullPublishUrl"
        $result = Invoke-WebRequest -Uri $fullPublishUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
        $result.Content

        $indexes = $config.PulishIndexes
        if($indexes) {
                $rebuildIndexUrl = "$baseUrl/bob/rebuildIndexes?indexes=$indexes"
                Write-Verbose "Rebuild indexes with on $rebuildIndexUrl"
                $result = Invoke-WebRequest -Uri $rebuildIndexUrl -Headers @{ "Authenticate" = $deploymentToolAuthToken } -TimeoutSec 10800 -UseBasicParsing
                $result.Content
        }
    }
}
