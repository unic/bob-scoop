<#
.SYNOPSIS
Restores all databases of a project from a file share.
.DESCRIPTION
Restores all databases which are referenced in the ConnectionStrings file of the project to the local database server.
The backup will be copied to the C:\Temp directory before restoring it.
The location of the backups to restore must be configured in the Bob.config file.
If a database already exists it will be replaced. If not it will be created at the default location or in the DatabasePath.


.PARAMETER ProjectPath
The path to the Website project.


.PARAMETER DatabasePath
The path where databases which does not exists yet should be created.

.EXAMPLE
Import-ScDatabases
.EXAMPLE
Import-ScDatabases -DatabasePath D:\databases
#>
Function Import-ScDatabases
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [string] $ProjectPath,
        [String] $DatabasePath
    )
    Begin{}

    Process
    {
        $config = Get-ScProjectConfig $ProjectPath

        $BackupShare = $config.DatabaseBackupShare;

        if((-not $BackupShare) -or ( -not (Test-Path $BackupShare))) {
            Write-Error "The backups location '$($BackupShare)' could not be found, please check if you have access to this location and if it is well configured in the Bob.config file."
            exit
        }

        $dbutils = ResolvePath -PackageId "adoprog\Sitecore-PowerCore" -RelativePath "Framework\DBUtils"
        Import-Module $dbutils -Force

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

        $serverManager = New-Object Microsoft.Web.Administration.ServerManager
        if($serverManager.ApplicationPools) {
            $appPoolName = $config.WebsiteCodeName
            if($appPoolName) {
                $appPool = $serverManager.ApplicationPools[$appPoolName]
                if($appPool -and $appPool.State -eq "Started") {
                    $appPool.Stop() | Out-Null
                    Write-Verbose "Stopped application pool $appPoolName"
                    while( $appPool.State -ne "Stopped") {
                        sleep -s 1
                    }
                }
            }
        }

        $myTemp = "C:\temp"
        if(-not (Test-Path $myTemp)) {
            Write-Verbose "Creating temp path $myTemp"
            mkdir $myTemp | Out-Null
        }

        foreach($databaseName in $databases) {
            $database = $sqlServer.databases[$databaseName]
            if(-not $database)
            {

                try {
                    Create-Database $sqlServer $databaseName -DatabasePath $DatabasePath
                }

                catch {
                    $sqlEx = (GetSqlExcpetion $_.Exception )
                    if($sqlEx) {
                        Write-Error $sqlEx
                    }
                    else {
                        Write-Error $_
                    }
                    continue
                }

            }
            $file = ls ($BackupShare + "\" ) | ? {$_.Name -like "$databaseName*.bak" } | select -Last 1
            if($file) {
                $tempPath = "$myTemp\$($file.Name)"
                Write-Verbose "Copy backup file from $($file.FullName) to $tempPath"
                cp $file.FullName $tempPath

                try {
                    $sqlServer.KillAllProcesses($databaseName);
                    Restore-Database $sqlServer $databaseName ($tempPath)
                }
                catch {
                    $sqlEx = (GetSqlExcpetion $_.Exception )
                    if($sqlEx) {
                        Write-Error $sqlEx
                    }
                    else {
                        Write-Error $_
                    }
                }
                finally {
                    rm $tempPath
                }
            }
            else {
                Write-Error "No *.bak file found for database $databaseName on file share $BackupShare"
            }

       }

        if(-not (ls $myTemp)) {
            rm $myTemp
        }

       if($appPool -and $appPool.State -eq "Stopped") {
           $appPool.Start()
           while( $appPool.State -ne "Started") {
               sleep -s 1
           }
       }

    }

    End{}
}

function GetSqlExcpetion {
    param ($ex)

    if($ex -is [System.Data.SqlClient.SqlException]) {
        $ex
    }
    else{
        if($ex.InnerException) {
            GetSqlExcpetion $ex.InnerException
        }
    }
}
