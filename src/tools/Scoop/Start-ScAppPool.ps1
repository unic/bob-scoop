<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

#>
function Start-ScAppPool
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
            Write-Verbose "Start application pool $appPool"
            Start-WebAppPool $config.WebsiteCodeName
        }
        else {
            Write-Warning "Could not find application pool for project $ProjectPath"
        }

        }
    }
}
