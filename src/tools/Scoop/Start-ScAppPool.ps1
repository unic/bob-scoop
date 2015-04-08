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
        Start-WebAppPool $config.WebsiteCodeName
        }
    }
}
