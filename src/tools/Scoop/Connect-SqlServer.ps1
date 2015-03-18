<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

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
