<#
.SYNOPSIS
Get the current major Sitecore version.

.DESCRIPTION
Get the current major Sitecore version.

.PARAMETER ProjectPath
The path to the project to get the information for.

#>
function Get-ScMajorVersion
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $contextInfo = Get-ScContextInfo $ProjectPath
        return $contextInfo.Version.Substring(0, $contextInfo.Version.IndexOf("."))
    }
}
