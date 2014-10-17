function Copy-UnmanagedFiles
{
  [CmdletBinding()]
  Param()
  Process
  {
    $config = Get-ScProjectConfig
    $webPath = Join-Path (Join-Path  $config.GlobalWebPath ($config.WebsiteCodeName)) $config.WebFolderName
    Copy-FilesByPattern -Source $config.WebsitePath -Target $webPath -FilePatterns $config.UnmanagedFiles
  }
}
