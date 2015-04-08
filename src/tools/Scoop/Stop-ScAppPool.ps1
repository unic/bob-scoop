<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

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

        $startTime = Get-Date
        if(-not ((Get-WebAppPoolState $config.WebsiteCodeName).Value -eq "Stopped")) {
            Stop-WebAppPool $config.WebsiteCodeName
            while(((Get-WebAppPoolState $config.WebsiteCodeName).Value -ne "Stopped") `
                -and ((Get-Date) - $startTime).TotalSeconds -lt 60) {
                sleep -s 1
            }
        }
        }
    }
}
