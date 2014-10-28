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
              $backupArgs["Pattern"] = Get-RubblePattern $config.UnmanagedFiles
            }
            Copy-RubbleItem -Path $webPath -Destination $tempBackup @backupArgs
            if($Backup) {
              if(-not (Test-Path $backupPath)) {
                mkdir $backupPath | Out-Null
              }
              $backupFile = Join-Path $backupPath "Fullbackup.zip"
              if(Test-Path $backupFile) {
                Write-Verbose "Remove backup file $backupFile"
                rm $backupFile
              }

              Write-RubbleArchive -Path $webPath -OutputLocation $backupFile

            }
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
        Copy-RubbleItem -Destination $webPath -Path $tempBackup -Pattern (Get-RubblePattern $config.UnmanagedFiles)
        Merge-ConnectionStrings -OutputLocation (Join-Path $webPath $config.ConnectionStringsFolder)
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
