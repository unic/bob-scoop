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
If $true a backup of the entire WebRoot will be done before everything gets overwritten by Scoop. Default is $false

.PARAMETER Force
If $false nothing will be done if the WebRoot is not empty.

.EXAMPLE
Install-Sitecore

.EXAMPLE
Install-Sitecore -Backup:$true

.EXAMPLE
Install-Sitecore -Force:$false

#>
function Install-Sitecore
{
    [CmdletBinding()]
    Param(
        [switch] $Backup = $false,
        [switch] $Force = $true,
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
                    $ExistingFolder = Test-Path $webPath -and (ls $webPath).Count -gt 0

                    if($ExistingFolder -and -not ($Backup -or -$Force)) {
                        Write-Warning "Web folder $webPath already exists and Force is false. Nothing will be done."
                        return
                    }

                    if($Backup -and $ExistingFolder) {
                        Write-Verbose "Backup $webPath to temporary location $tempBackup"
                        mv $webPath\* $tempBackup

                        $backupFile = Join-Path $backupPath "Fullbackup.zip"
                        if(Test-Path $backupFile) {
                            Write-Verbose "Remove old backup file $backupFile"
                            rm $backupFile
                        }
                        Write-Verbose "Write backup to $backupFile"
                        Write-RubbleArchive -Path $tempBackup -OutputLocation $backupFile
                    }

                    if((Get-ScMajorVersion $ProjectPath) -ge 9){
                        $installData = Get-ScInstallData $ProjectPath
                        Write-Host "Installing Sitecore..."
                        Install-SitecoreSetup `
                            -ModuleSifPath $installData.SifPath `
                            -ModuleFundamentalsPath $installData.FundamentalsPath `
                            -SifConfigPathSitecoreXp0 $installData.SifConfigPathSitecoreXp0 `
                            -SitecorePackagePath $installData.SitecorePackagePath `
                            -LicenseFilePath $installData.LicenseFilePath `
                            -SifConfigPathCreateCerts $installData.SifConfigPathCreateCerts `
                            -CertPathFolder $installData.CertCreationLocation
                    }
                    else {
                        Write-Verbose "Web folder $webPath already exists and Force is true. Overwrite web folder."
                        Write-Verbose "Install Sitecore distribution to $webPath"
                        Install-SitecorePackage -OutputLocation $webPath -ProjectPath $ProjectPath    
                    }
                }
                catch
                {
                    Write-Error $_
                }
                finally
                {
                    if (-not $config.WebRootConnectionStringsPath)
                    {
                        Write-Error "The WebRootConnectionStringsPath setting must be set in order to handle connection strings correctly."
                    }
                    
                    if(Test-Path (Join-Path $webPath $config.WebRootConnectionStringsPath))
                    {
                        Merge-ConnectionStrings -OutputLocation (Join-Path $webPath $config.WebRootConnectionStringsPath) -ProjectPath $ProjectPath
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
