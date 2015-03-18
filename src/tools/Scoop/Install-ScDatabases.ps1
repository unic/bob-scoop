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
        [string] $DatabasePath
    )
    Process
    {
        Invoke-BobCommand {

        $dbutils = ResolvePath -PackageId "adoprog\Sitecore-PowerCore" -RelativePath "Framework\DBUtils"
        Import-Module $dbutils -Force

        $config = Get-ScProjectPath $ProjectPath

        $sqlServer = Connect-SqlServer $ProjectPath

        $scContext = Get-ScContextInfo $ProjectPath

        $cacheLocation = "${env:AppData}\Bob\DatabasesCache\"
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

        $databases = Get-ScDatabases $ProjectPath

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

                try {
                    Attach-Database $sqlServer $db $mdfTarget $ldfTarget
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
            }
        }
        }

    }
}
