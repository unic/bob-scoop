$ErrorActionPreference = "Stop"

function ResolvePath() {
  param($PackageId, $RelativePath)
  $paths = @("$PSScriptRoot\..\..\..\paket-files", "$PSScriptRoot\..\..\..\packages", "$PSScriptRoot\..\paket-files", "$PSScriptRoot\..\packages")
  foreach($packPath in $paths) {
    $path = Join-Path $packPath "$PackageId\$RelativePath"
    if((Test-Path $packPath) -and (Test-Path $path)) {
      Resolve-Path $path
      return
    }
  }
  Write-Error "No path found for $RelativePath in package $PackageId"
}


$partentPath = (Get-Item $PSScriptRoot).Parent.FullName

Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude "*.Tests.ps1" | Foreach-Object{ . $_.FullName }
Export-ModuleMember -Function * -Alias *
