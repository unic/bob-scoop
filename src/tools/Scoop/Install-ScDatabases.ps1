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
            Install-SitecoreNugetPackage `
                -PackageId Sitecore.Databases `
                -Version $scContext.Version `
                -ProjectPath $ProjectPath `
                -OutputLocation $dbCache
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
                else {
                    if($config.DatabasesPath) {
                        $dbsPath = Join-Path $config.WebsitePath $config.DatabasesPath
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
                        Write-Warning "$db is not a Sitecore database and 'DatabasesPath' is not set in Bob.config"
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
        }

    }
}
