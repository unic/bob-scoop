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
database will then be used to create this database. On a Sitecore 9 instance the corresponding
.dacpac packages will be used for the creation.
The "InitDatabasesPath" can be configured in the Bob.config

.PARAMETER ProjectPath
The path to the project for which the databases should be installed.

.PARAMETER DatabasesPath
The path where the databases should be created.

.PARAMETER Force
If force is specified, all databases which already exist will be deleted first.
Specifying force on a Sitecore 9 instance will invoke the Scratch/Sif task for installing all Sitecore DBs (excluding xconnect).
If force is not specified, existing databases will be skipped.

.PARAMETER Databases
An alternative list of databases to install. If it's ommited the databases from
 the connection string will be used.

.EXAMPLE
Install-ScDatabases -DatabasePath C:\data

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
        $VerbosePreference = "SilentlyContinue"
        Import-Module $dbutils -Force
        $VerbosePreference = "Continue"

        $config = Get-ScProjectConfig $ProjectPath
        $sqlServer = Connect-SqlServer $ProjectPath
        $scContext = Get-ScContextInfo $ProjectPath

        $scMajorVersion = Get-ScMajorVersion $ProjectPath
        if($scMajorVersion -ge 9){
            $dbCache = Install-NugetPackageToCache -Version $config.SitecoreXp0WdpVersion -PackageId "Sitecore.Xp0.Wdp"
            Expand-RubbleArchive `
                -Path $(Join-Path $dbCache "xp0.scwdp.zip") `
                -OutputLocation $dbCache `
                -FileFilter ".dacpac$"
        }
        else{
            $dbCache = Install-NugetPackageToCache `
            -PackageId Sitecore.Databases `
            -Version $scContext.version `
            -ProjectPath $ProjectPath
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
            $isNonSitecoreDatabase = $false;
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
                elseif(($db -like "*_analytics" -or $db -like "*_reporting") -and (Test-Path "$dbCache\Sitecore.Analytics.mdf")) {
                    $scDb = "Sitecore.Analytics"
                }
                elseif($db -like "*_sessions") {
                    $scDb = "Sitecore.Sessions"
                }
                elseif($db -like "*_EXM.Master" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Exm.master"
                }
                elseif($db -like "*_ExperienceForms" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Experienceforms"
                }
                elseif($db -like "*_MarketingAutomation" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Marketingautomation"
                }
                elseif($db -like "*_Messaging" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Messaging"
                }
                elseif($db -like "*_Processing.Pools" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Processing.pools"
                }
                elseif($db -like "*_Processing.Tasks" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Processing.tasks"
                }
                elseif($db -like "*_ReferenceData" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Referencedata"
                }
                elseif($db -like "*_Reporting" -and $scMajorVersion -ge 9) {
                    $scDb = "Sitecore.Reporting"
                }
                else {
                    if($config.InitDatabasesPath) {
                        $isNonSitecoreDatabase = $true
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

                    if($scMajorVersion -ge 9){
                        if($isNonSitecoreDatabase){
                            $dacPacName = "$scDb.dacpac"
                            $dacPacPath = Join-Path $dbCache $dacPacName
                            Write-Verbose "Using $dacPacPath for creation of $db"
                            Install-DataTierApplication $dacPacPath $db $config.DatabaseServer $ProjectPath
                        }
                    }
                    else{
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
                }
                if($sql) {
                    Write-Verbose "Create database $db by executing SQL script."
                    Invoke-SqlCommand {
                        $sqlServer.Databases["master"].ExecuteNonQuery($sql)
                    }
                }
            }
        }

        if($Force -and $scMajorVersion -ge 9){
            Write-Verbose "Invoking creation of all Sitecore 9 databases"
            $installData = Get-Sc9InstallData $ProjectPath
            Install-Sitecore12Databases `
                -ModuleSifPath $installData.SifPath `
                -ModuleFundamentalsPath $installData.FundamentalsPath `
                -SifConfigPathSitecoreXp0 $installData.SifConfigPathSitecoreXp0 `
                -SitecorePackagePath $installData.SitecorePackagePath
        }

        if($stoppedWebAppPool) {
            Start-ScAppPool $ProjectPath
        }

        }

    }
}
