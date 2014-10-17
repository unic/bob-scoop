[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\..\tools\SharpZipLib\lib\20\ICSharpCode.SharpZipLib.dll") | Out-Null

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
              $backupArgs["FilePatterns"] = $config.UnmanagedFiles
            }
            Backup-ScWebRoot -WebRoot $webPath -BackupFolder $tempBackup @backupArgs
            if($Backup) {
              if(-not (Test-Path $backupPath)) {
                mkdir $backupPath | Out-Null
              }
              $backupFile = Join-Path $backupPath "Fullbackup.zip"
              if(Test-Path $backupFile) {
                Write-Verbose "Remove backup file $backupFile"
                rm $backupFile
              }
              $zip = New-Object ICSharpCode.SharpZipLib.Zip.FastZip
              $zip.CreateZip($backupFile, $tempBackup,$true, $null)

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
        Restore-ScWebRootUnmanaged -WebRoot $webPath -BackupFolder $tempBackup -FilePatterns $config.UnmanagedFiles
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
