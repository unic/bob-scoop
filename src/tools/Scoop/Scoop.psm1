#Requires -Version 3

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

if(Test-Path "C:\windows\system32\inetsrv\Microsoft.Web.Administration.dll") {
    [System.Reflection.Assembly]::LoadFrom("C:\windows\system32\inetsrv\Microsoft.Web.Administration.dll") | out-null
}
else {
    Write-Warning "Could not find the Microsoft.Web.Administration.dll from IIS. All cmdlets using IIS won't work."
}

$partentPath = (Get-Item $PSScriptRoot).Parent.FullName

Get-ChildItem -Path $PSScriptRoot\*.ps1 -Exclude "*.Tests.ps1" | Foreach-Object{ . $_.FullName }
Export-ModuleMember -Function * -Alias *

Import-Module (ResolvePath "Unic.Bob.Config" "tools\BobConfig") -Force
Import-Module (ResolvePath "Unic.Bob.Rubble" "tools\Rubble") -Force
Import-Module (ResolvePath "Unic.Bob.Skip" "Skip") -Force
Import-Module (ResolvePath "Unic.Bob.Lofty" "Lofty") -Force

$nugetCore = [System.IO.File]::ReadAllBytes((ResolvePath "NuGet.Core" "lib\net40-Client\NuGet.Core.dll"))
[System.Reflection.Assembly]::Load($nugetCore)

$VerbosePreference = "Continue"
$ScoopCertificatePath = "O=Unic AG, OU=Unic AG"

function ResolveBinPath() {
    param($Path)

    $paths = @("$PSScriptRoot\..\..\..\tools", "$PSScriptRoot\..\bin")
    foreach($toolPath in $paths ) {
        $binPath = Join-Path $toolPath $Path
        if(Test-Path $binPath) {
            Resolve-Path $binPath
            return
        }
    }

    Write-Error "No bin path found for $Path"

}
