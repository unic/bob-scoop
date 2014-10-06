function Install-Sitecore
{
  [CmdletBinding()]
  Param(
    [switch]$Force = $True
  )
  Process
  {
    $config = Get-ScProjectConfig
    $webPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.WebFolderName
    $backupPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.BackupFolderName
    $filePatterns = $config.BackupFilter

    if((Test-Path $webPath) -and (ls $webPath).Count -gt 0)
    {
      if($Force)
      {
        Write-Verbose "Web folder $webPath allready exists and Force is true. Backup and delete web folder."
        Write-Verbose "Backup $webPatah to $backupPath"
        Backup-ScWebRoot -WebRoot $webPath -BackupFolder $backupPath -FilePatterns $filePatterns
        rm $webPath -Recurse -Force
      }
      else
      {
        Write-Warning "Web folder $webPath allready exists and Force is false. Nothing will be done."
        return
      }
    }

    Install-SitecorePackage -OutputLocation $webPath
  }
}
