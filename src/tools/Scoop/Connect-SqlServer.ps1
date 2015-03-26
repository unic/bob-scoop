<#
.SYNOPSIS
Connects to the SQL server configured in the project.

.DESCRIPTION
Connects to the SQL server configured in the Bob.config of the specified project
and returns a SMO server object which can be used to manage the server.

.PARAMETER ProjectPath
The path to project to use to get the name of the SQL server.

.EXAMPLE
$server = Connect-SqlServer
#>
function Connect-SqlServer
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        $Server = $config.DatabaseServer
        if(-not $Server) {
            Write-Error "Could not find database server in Bob.config. Add the config key 'DatabaseServer' to configure the database server to use"
        }
        $sqlServer = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $server

        try {
            if(-not $sqlServer.Version) {
                Write-Error "Could no connect to SQL Server '$server'"
                exit
            }
        }
        catch {
            Write-Error "Could no connect to SQL Server '$server'"
            exit
        }

        $sqlServer
    }
}
