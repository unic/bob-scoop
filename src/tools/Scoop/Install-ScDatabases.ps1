<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

#>
function Install-ScDatabases
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $dbutils = ResolvePath -PackageId "adoprog\Sitecore-PowerCore" -RelativePath "Framework\DBUtils"
        Import-Module $dbutils -Force

        $config = Get-ScProjectPath $ProjectPath
        $databases = Get-ScDatabases $ProjectPath

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

        $scContext = Get-ScContextInfo $ProjectPath

        $cacheLocation = "${env:AppData}\Bob\DatabasesCache\"
        if(-not (Test-Path $cacheLocation)) {
            mkdir $cacheLocation | Out-Null
        }

        Install-ScNugetPackage -PackageId Sitecore.Databases -Version $scContext.Version -ProjectPath $ProjectPath -OutputLocation

        foreach($db in $databases) {
            $scDb = ""
            if($db -like "*_core") {
                $scDb = "Sitecore.Core"
            }
            elseif($db -like "*_master") {
                $scDb = "Sitecore.Master"
            }
            elseif($db -like "*_web") {
                $scDb = "Sitecore.Web"
            }
        }
    }
}
