function Install-Sitecore
{
  [CmdletBinding()]
  Param(
    [switch]$Backup = $true,
    [switch]$Force = $true
  )
  Process
  {
    try {
      $config = Get-ScProjectConfig
      $webPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.WebFolderName
      $backupPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.BackupFolderName

      $tempBackup = Join-Path $env:TEMP ([GUID]::NewGuid())
      mkdir $tempBackup | Out-Null

      try
      {

        if((Test-Path $webPath) -and (ls $webPath).Count -gt 0)
        {
          if($Force)
          {
            Write-Verbose "Web folder $webPath allready exists and Force is true. Backup and delete web folder."
            Write-Verbose "Backup $webPath to $backupPath"
            $backupArgs = @{}
            if(-not $Backup) {
              $backupArgs["FilePatterns"] = $config.UnamangedFilter
            }
            Backup-ScWebRoot -WebRoot $webPath -BackupFolder $tempBackup @backupArgs
            rm $webPath -Recurse -Force
          }
          else
          {
            Write-Warning "Web folder $webPath allready exists and Force is false. Nothing will be done."
            return
          }
        }

        Write-Verbose "Install Sitecore distribution to $webPath"
        Install-SitecorePackage -OutputLocation $webPath
      }
      catch {
        Write-Error $_
      }
      finally {
        Restore-ScWebRootUnmanaged -WebRoot $webPath -BackupFolder $tempBackup -FilePatterns $config.UnamangedFilter
      }
    }
    catch {
      Write-Error $_
    }
    finally {
      if(Test-Path $tempBackup) {
        rm $tempBackup -Recurse
      }
    }
  }
}
