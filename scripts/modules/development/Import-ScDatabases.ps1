Function Import-ScDatabases
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$ConnectionStringsFile = "",
        [String]$VSProjectRootPath = "",
        [String]$ProjectRootPath = "",
        [String]$DatabasePath = ""
    )
    Begin{}

    Process
    {

        if(-not $VSProjectRootPath -and (Get-Command | ? {$_.Name -eq "Get-Project"})) {
            $project = Get-Project 
            if($project) {
                $VSProjectRootPath = Split-Path $project.FullName -Parent
            }
        }

        if(-not $ProjectRootPath -and (Get-Command | ? {$_.Name -eq "Get-ScProjectRootPath"})) {
            $ProjectRootPath = Get-ScProjectRootPath
        }

        if(-not $ProjectRootPath) {
            throw "ProjectRootPath not found. Please provide one."
        }


        
        $localSetupConfig = Get-ScProjectConfig
        $Server = $localSetupConfig.DatabaseServer;
        $BackupShare = $localSetupConfig.DatabaseBackupShare;

        if(-not $ConnectionStringsFile -and $VSProjectRootPath) {
                $ConnectionStringsFile = Join-Path $VSProjectRootPath $localSetupConfig.ConnectionStringsFolder
        }

        if(-not $ConnectionStringsFile) {
            throw "No ConnectionStringsFile found. Please provide one."
        }

        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        $scriptPath = Split-Path $scriptInvocation.MyCommand.Path

        Import-Module  (Join-Path $scriptPath "..\..\..\tools\sitecore-powercore\DBUtils.psm1") -Force
        Write-Verbose "Start  Import-ScDatabases with params:  -ConnectionStringsFile '$ConnectionStringsFile' -ProjectRootPath '$ProjectRootPath' -VSProjectRootPath '$VSProjectRootPath'";

        $config = [xml](Get-Content $ConnectionStringsFile)
       
        $databases = @();
        
        foreach($item in $config.connectionStrings.add) {
            $connectionString = $item.connectionString;
            $parts = $connectionString.split(';');
            foreach($part in $parts) 
            {
                $keyValue = $part.split('=');
                if($keyValue[0].trim() -eq "Database") {
                    $databases += $keyValue[1]
                }
            }
        }


       $sqlServer = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $server


       foreach($databaseName in $databases) {
            $database = $sqlServer.databases[$databaseName]
            if(-not $database)
            {
                Create-Database $sqlServer $databaseName -DatabasePath $DatabasePath
            }
            $file = ls ($BackupShare + "\" ) | ? {$_.Name -like "$databaseName*.bak" } | select -Last 1
            $file.FullName

            
            $sqlServer.KillAllProcesses($databaseName);
            try {
                Restore-Database $sqlServer $databaseName ($file.FullName)
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
      
       Write-Verbose "End  Import-ScDatabases with params:  -ConnectionStringsFile '$ConnectionStringsFile' -ProjectRootPath '$ProjectRootPath' -VSProjectRootPath '$VSProjectRootPath' -DatabasePath '$DatabasePath'";

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
