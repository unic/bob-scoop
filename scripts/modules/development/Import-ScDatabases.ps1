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

        if((-not $BackupShare) -or ( -not (Test-Path $BackupShare))) {
            Write-Error "The backups location '$($BackupShare)' could not be found, please check if you have access to this location and if it is well configured in the Bob.config file."
            exit
        }
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

        if((-not $ConnectionStringsFile) -or -not (Test-Path $ConnectionStringsFile)) {
            Write-Error "Could not find ConnectionStrings file at '$ConnectionStringsFile'"
            exit
        }

        $config = [xml](Get-Content $ConnectionStringsFile)
       
        $databases = @();
        
        if(-not $config.connectionStrings.add) {
            Write-Warning "No ConnectionStrings found in '$ConnectionStringsFile'"
        }

        foreach($item in $config.connectionStrings.add) {
            $connectionString = $item.connectionString;
            if(-not $item.connectionString) {
                Write-Warning "ConnectionString '$($item.name)' in '$ConnectionStringsFile' is empty."
            }

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


        foreach($databaseName in $databases) {
            $database = $sqlServer.databases[$databaseName]
            if(-not $database)
            {
                Create-Database $sqlServer $databaseName -DatabasePath $DatabasePath
            }
            $file = ls ($BackupShare + "\" ) | ? {$_.Name -like "$databaseName*.bak" } | select -Last 1
            if($file) {
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
            else {
                Write-Error "No *.bak file found for database $databaseName on file sharee $BackupShare"
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
