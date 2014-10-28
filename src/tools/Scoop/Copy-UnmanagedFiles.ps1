function Copy-UnmanagedFiles
{
  [CmdletBinding()]
  Param()
  Process
  {
    $config = Get-ScProjectConfig
    $webPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.WebFolderName
    Copy-RubbleItem -Path $config.WebsitePath -Destination $webPath -Pattern (Get-RubblePattern $config.UnmanagedFiles)
  }
}
