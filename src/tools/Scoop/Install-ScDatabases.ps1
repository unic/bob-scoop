<#
.SYNOPSIS
Installs all databases of the project based on empty databases.


.DESCRIPTION
Installs all databases of the project based on different criterias:
- The Sitecore Core, Master and Web will be created based on the original
databases from Sitecore.
- For all other databases the information from the "InitDatabasesPath"  is relevant.
If in the database path a file exists with the format "databaseName.sql",
this SQL file will be used to create the database.
If in the database path a file exists with the format "databaseName.ref",
the file content must be "web", "master" or "core", the coresponding original Sitecore
database will then be used to create this database.
The "InitDatabasesPath" can be configured in the Bob.config

.PARAMETER ProjectPath
The path to the project for which the databases should be installed.

.PARAMETER DatabasesPath
The path where the databases should be created.

.PARAMETER Force
If force is specified, all databases which already exist will be deleted first.
If force is not specified, existing databases will be skipped.

.PARAMETER Databases
An alternative list of databases to install. If it's ommited the databases from
 the connection string will be used.

.EXAMPLE

#>
function Install-ScDatabases
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath,
        [string] $DatabasePath,
        [switch] $Force,
        [string[]] $Databases
    )
    Process
    {
        Invoke-BobCommand {

        $dbutils = ResolvePath -PackageId "adoprog\Sitecore-PowerCore" -RelativePath "Framework\DBUtils"
        Import-Module $dbutils -Force

        $config = Get-ScProjectConfig $ProjectPath
        $sqlServer = Connect-SqlServer $ProjectPath
        $scContext = Get-ScContextInfo $ProjectPath

        $cacheLocation = "${env:AppData}\Bob\DatabasesCache"
        if(-not (Test-Path $cacheLocation)) {
            mkdir $cacheLocation | Out-Null
        }

        $dbCache = "$cacheLocation\$($scContext.version)"

        if(-not (Test-Path $dbCache)) {
            Install-NugetPackage `
                -PackageId Sitecore.Databases `
                -Version $scContext.Version `
                -ProjectPath $ProjectPath `
                -OutputLocation $dbCache
        }

        $stoppedWebAppPool = $false
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
        if($Force -and $config.WebsiteCodeName -and $isAdmin) {
            $stoppedWebAppPool = $true
            Stop-ScAppPool $ProjectPath
        }

        if($DatabasePath -and (-not (Test-Path $DatabasePath))) {
            mkdir $DatabasePath
        }

        if(-not $Databases) {
            $databases = Get-ScDatabases $ProjectPath
        }

        foreach($db in $databases) {
            if(-not $sqlServer.Databases[$db] -or $Force) {
                $scDb = ""
                $sql = ""
                if($db -like "*_core") {
                    $scDb = "Sitecore.Core"
                }
                elseif($db -like "*_master") {
                    $scDb = "Sitecore.Master"
                }
                elseif($db -like "*_web") {
                    $scDb = "Sitecore.Web"
                }
                elseif($db -like "*_analytics" -and (Test-Path "$dbCache\Sitecore.Analytics.mdf")) {
                    $scDb = "Sitecore.Analytics"
                }
                elseif($db -like "*_sessions") {
                    $scDb = "Sitecore.Sessions"
                }
                else {
                    if($config.InitDatabasesPath) {
                        $dbsPath = Join-Path $config.WebsitePath $config.InitDatabasesPath
                        Write-Verbose "$db is not a Sitecore database. Looking in $dbsPath for additional infos."

                        ls $dbsPath | ? {$_.BaseName.ToLower() -eq $db.ToLower()} | % {
                            $content = (Get-Content $_.FullName -Raw).Trim()
                            if($_.Extension -eq ".ref") {
                                $scDbNames = @("core", "web", "master")
                                if($scDbNames -contains $content.ToLower()) {
                                    $scDb = "Sitecore.$content"
                                }
                                else {
                                    Write-Warning "$($_.Fullname) contains no valid database name. Valid names are $($scDbNames | Out-String)"
                                }
                            }
                            elseif($_.Extension -eq ".sql") {
                                $sql = $content
                            }
                        }
                    }
                    else {
                        Write-Warning "$db is not a Sitecore database and 'InitDatabasesPath' is not set in Bob.config"
                    }
                }

                if(($scDb -or $sql) -and $Force) {
                    Write-Verbose "Delete database $db"
                    Invoke-SqlCommand {
                        Delete-Database $sqlServer $db
                    }
                }

                if($scDb) {
                    if($DatabasePath) {
                        $dataFileFolder = $DatabasePath
                        $logFileFolder = $DatabasePath

                    }
                    else {
                	    $dataFileFolder = $sqlServer.Settings.DefaultFile
                	    $logFileFolder = $sqlServer.Settings.DefaultLog
                    }

                    $mdfSource = "$dbCache\$scDb.mdf"
                    $ldfSource = "$dbCache\$scDb.ldf"
                    $mdfTarget = "$dataFileFolder\$db.mdf"
                    $ldfTarget = "$logFileFolder\$db.ldf"

                    Write-Verbose "Copy database file $mdfSource to $mdfTarget"
                    cp $mdfSource $mdfTarget

                    Write-Verbose "Copy database file $ldfSource to $ldfTarget"
                    cp $ldfSource $ldfTarget

                    Invoke-SqlCommand {
                        Attach-Database $sqlServer $db $mdfTarget $ldfTarget
                    }
                }
                if($sql) {
                    Write-Verbose "Create database $db by executing SQL script."
                    Invoke-SqlCommand {
                        $sqlServer.Databases["master"].ExecuteNonQuery($sql)
                    }
                }
            }
        }

        if($stoppedWebAppPool) {
            Start-ScAppPool $ProjectPath
        }

        }

    }
}
