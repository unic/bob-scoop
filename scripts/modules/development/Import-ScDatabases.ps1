Function Import-ScDatabases
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
		[String]$ConnectionStringsFile = "",
        [String]$VSProjectPath = "",
        [String]$ProjectPath =""
	)
    Begin{}

    Process
    {

        if(-not $VSProjectPath -and (Get-Command | ? {$_.Name -eq "Get-Project"})) {
			$project = Get-Project 
			if($project) {
				$VSProjectPath = Split-Path $project.FullName -Parent
			}
		}

        if(-not $ProjectPath -and $VSProjectPath) {
            $ProjectPath = Split-Path $VSProjectPath -Parent
        }

        if(-not $ProjectPath) {
            throw "ProjectPath could not be found. Please provide one."
        }


        

		$Server = $localSetupConfig.DatabaseServer;
        $BackupShare = $localSetupConfig.DatabaseBackupShare;

        if(-not $ConnectionStringsFile -and $VSProjectPath) {
				$ConnectionStringsFile = Join-Path $VSProjectPath $localSetupConfig.ConnectionStringsFolder
        }

        if(-not $ConnectionStringsFile) {
            throw "No ConnectionStringsFile found. Please provide one."
        }

        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        $scriptPath = Split-Path $scriptInvocation.MyCommand.Path

		Import-Module  (Join-Path $scriptPath "..\..\..\tools\sitecore-powercore\DBUtils.psm1") -Force
        Write-Verbose "Start  Import-ScDatabases with params:  -ConnectionStringsFile '$ConnectionStringsFile' -ProjectPath '$ProjectPath' -VSProjectPath '$VSProjectPath'";

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
                Create-Database $sqlServer $databaseName
            }
            $file = ls ($BackupShare + "\" ) | ? {$_.Name -like "$databaseName*.bak" } | select -Last 1
            $file.FullName

            
            $sqlServer.KillAllProcesses($databaseName);

            Restore-Database $sqlServer $databaseName ($file.FullName)

       }
	  
       Write-Verbose "End  Import-ScDatabases with params:  -ConnectionStringsFile '$ConnectionStringsFile' -ProjectPath '$ProjectPath' -VSProjectPath '$VSProjectPath'";

    }

    End{}
}
