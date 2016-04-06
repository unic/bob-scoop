<#
.SYNOPSIS
Installs Sitecore with the correct version to the WebRoot

.DESCRIPTION
Installs Sitecore distribution with the correct version to the WebRoot
of the current project.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website project.
Optionally a backup of the WebRoot will be performed before everything will be overwritten.
In each case all unmanaged files will be backed-up and restored.
Additionally the connectionStrings.config file will be transformed by taking the ConnectionStrings.config
from the project as base, and the name of the SQL instance  from Bob.config.

.PARAMETER Backup
If $true a backup of the entire WebRoot will be done before everything gets overwritten by Scoop.

.PARAMETER Force
If $false nothing will be done if the WebRoot is not empty.

.EXAMPLE
Install-Sitecore

.EXAMPLE
Install-Sitecore -Backup:$false

.EXAMPLE
Install-Sitecore -Force:$false

#>
function Install-Sitecore
{
    [CmdletBinding()]
    Param(
        [switch]$Backup = $true,
        [switch]$Force = $true,
        [string] $ProjectPath
    )
    Process
    {
        Invoke-BobCommand {

        try
        {
            $config = Get-ScProjectConfig $ProjectPath
            $webPath = $config.WebRoot
            if(-not $WebPath) {
                Write-Error "Could not find WebRoot. Please provide one."
            }
            $backupPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.BackupFolderName

            $tempBackup = Join-Path $backupPath ([GUID]::NewGuid())
            mkdir $tempBackup | Out-Null
            Stop-ScAppPool $ProjectPath
            try
            {
                if((Test-Path $webPath) -and (ls $webPath).Count -gt 0)
                {
                    if($Force)
                    {
                        Write-Verbose "Web folder $webPath already exists and Force is true. Backup and delete web folder."

                        $backupArgs = @{}
                        if(-not $Backup) {
                            $backupArgs["Pattern"] = Get-RubblePattern $config.UnmanagedFiles
                        }
                        Write-Verbose "Backup $webPath to temporary location $tempBackup"
                        mv $webPath\* $tempBackup

                        if($Backup) {
                            $backupFile = Join-Path $backupPath "Fullbackup.zip"
                            if(Test-Path $backupFile) {
                                Write-Verbose "Remove old backup file $backupFile"
                                rm $backupFile
                            }
                            Write-Verbose "Write backup to $backupFile"
                            Write-RubbleArchive -Path $tempBackup -OutputLocation $backupFile
                        }
                    }
                    else
                    {
                        Write-Warning "Web folder $webPath already exists and Force is false. Nothing will be done."
                        return
                    }
                }

                Write-Verbose "Install Sitecore distribution to $webPath"

                Install-SitecorePackage -OutputLocation $webPath -ProjectPath $ProjectPath
            }
            catch
            {
                Write-Error $_
            }
            finally
            {
               if(Test-Path (Join-Path $webPath $config.ConnectionStringsFolder)) {
                    Merge-ConnectionStrings -OutputLocation (Join-Path $webPath $config.ConnectionStringsFolder) -ProjectPath $ProjectPath
                }
            }
        }
        catch
        {
            Write-Error $_
        }
        finally
        {
            Start-ScAppPool $ProjectPath
            if(Test-Path $tempBackup) {
                rm $tempBackup -Recurse
            }
        }
    }
    }
}
