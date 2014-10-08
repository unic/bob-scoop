function Merge-ConnectionStrings
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $OutputLocation
  )
  Process
  {
    $config = Get-ScProjectConfig
    $file = Join-Path $config.WebsitePath $config.ConnectionStringsFolder
    $server = $config.DatabaseServer
    $content = Get-Content $file
    #$content = $content -replace "Database=.*?;", "Database=$server;"
    $keys = @("Data Source", "Address","Addr", "Network Address",  "Server")

    foreach($key in $keys) {
      $content = $content -replace "$key=((?!;)(?!"").)*", "$key=$server"
    }
    $content | Out-File $OutputLocation -Encoding UTF8
  }
}
