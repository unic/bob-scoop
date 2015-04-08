<#
.SYNOPSIS
Adds a Windows User as SQL  administrator.

.DESCRIPTION
Adds a Windows User as SQL  administrator.

.PARAMETER Server
The name of the SQL server to connect to.

.PARAMETER User
The name of the user to register as admin.

.EXAMPLE
Add-SqlAdmin -Server localhost -User "NT Authority\Service"

#>
function Add-SqlAdmin
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Server,
        [Parameter(Mandatory=$true)]
        [string] $User
    )
    Process
    {
        $dbutils = ResolvePath -PackageId "adoprog\Sitecore-PowerCore" -RelativePath "Framework\DBUtils"
        $VerbosePreference = "SilentlyContinue"
        Import-Module $dbutils -Force
        $VerbosePreference = "Continue"

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

        $login = $sqlServer.Logins | ? {$_.Name.ToLower() -eq $User.ToLower()}

        if(-not $login) {
            $login = New-Object Microsoft.SqlServer.Management.Smo.Login $sqlServer, $user
            $login.LoginType = 'WindowsUser'
            $login.Create()
        }

        $login.AddToRole("sysadmin")
    }
}
