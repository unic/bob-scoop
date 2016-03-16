<#
.SYNOPSIS
Get the current Sitecore type and version.

.DESCRIPTION
Get the current Sitecore type and version.
It returns an object with the properties "type" (Mvc or WebForms) and "version".

.PARAMETER ProjectPath
The path to the project to get the information for.

.EXAMPLE

#>
function Get-ScContextInfo
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        return @{
              "type" = $config.SitecoreType; 
              "version" = $config.SitecoreVersion
        }
    }
}
