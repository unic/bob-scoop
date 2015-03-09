<#
.SYNOPSIS
Creates a ConnectionStrings.config by merging the file from the project and Bob.config.
.DESCRIPTION
Merge-ConnectionStrings reads the connectionStrings.config in the Website project
and replaces all SQL server/instance names with the value from the Bob.config.
The resulting file will then be written to a specified location.

.PARAMETER OutputLocation
The file path where to write the resulting connectionStrings.config

.EXAMPLE
Merge-ConnectionStrings D:\Webs\Magic\connectionStrings.config
#>
function Merge-ConnectionStrings
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $OutputLocation,
      [string] $ProjectPath
  )
  Process
  {
    $config = Get-ScProjectConfig $ProjectPath
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
