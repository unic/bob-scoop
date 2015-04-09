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
        Enable-ScSite
        Install-Sitecore
        Set-ScSerializationReference
        Install-ScDatabases
        $sb = $dte.Solution.SolutionBuild
        $sb.Clean($true)
        $sb.Build($true)
        Sync-ScDatabases
    }
}

Set-Alias bump Initialize-Environment
