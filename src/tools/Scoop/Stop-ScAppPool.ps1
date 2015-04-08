<#
.SYNOPSIS
Stops the application pool configured for the project.

.DESCRIPTION
Stops the application pool configured for the project.

.PARAMETER ProjectPath
The path to the Website project.

.EXAMPLE
Stop-ScAppPool

#>
function Stop-ScAppPool
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        Invoke-BobCommand {
        $VerbosePreference = "SilentlyContinue"
        Import-Module WebAdministration
        $VerbosePreference = "Continue"

        $config = Get-ScProjectConfig $ProjectPath

        $appPool = $config.WebsiteCodeName

        if($appPool -and (ls IIS:\AppPools\ | ? {$_.Name -eq $appPool})) {
            $startTime = Get-Date
            if(-not ((Get-WebAppPoolState $appPool).Value -eq "Stopped")) {
                Write-Verbose "Stop application pool $appPool"
                Stop-WebAppPool $appPool
                while(((Get-WebAppPoolState $appPool).Value -ne "Stopped") `
                    -and ((Get-Date) - $startTime).TotalSeconds -lt 60) {
                    sleep -s 1
                }
            }
        }
        else {
            Write-Warning "Could not find application pool for project $ProjectPath"
        }
        }
    }
}
