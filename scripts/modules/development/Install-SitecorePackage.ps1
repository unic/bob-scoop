function Install-SitecorePackage
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $OutputLocation
  )
  Process
  {

    $getInstance = [NuGet.VisualStudio.ServiceLocator].GetMethod("GetInstance")
    $getInstancePackagePackageRepo = $getInstance.MakeGenericMethod($nugetCore.GetType("NuGet.IPackageRepository"))
    $repository = $getInstancePackagePackageRepo.Invoke($null, $null)

    $packagesFolderFileSystem = New-Object $nugetCore.GetType("NuGet.PhysicalFileSystem")  $OutputLocation
    $pathResolver = New-Object CustomPathResolver ($packagesFolderFileSystem)
    $localRepository = New-Object $nugetCore.GetType("NuGet.LocalPackageRepository") ($pathResolver, $packagesFolderFileSystem);
    $localRepository.PackageSaveMode = "Nuspec"
    $packageManager = New-Object $nugetCore.GetType("NuGet.PackageManager") ($repository, $pathResolver, $packagesFolderFileSystem, $localRepository)
    $installed = $false
    $types = @("Mvc", "WebForms")
    $i = 0
    while((-not $installed) -and ($i -lt $types.Length)) {
        $type = $types[$i]
        $package = Get-Package -Filter "Sitecore.$type.Config"
        if($package) {
            Write-Verbose "Install Sitecore.Distribution.$type and $($package.Version)"
            $packageManager.InstallPackage("Sitecore.Distribution.$type", $($package.Version) )
            $installed = $true
        }
        $i++;
    }
  }
}

$nugetCoreName = [NuGet.VisualStudio.ServiceLocator].Assembly.GetReferencedAssemblies() | ? {$_.Name -eq "NuGet.Core"}
$nugetCore = [AppDomain]::CurrentDomain.GetAssemblies() | ? {$_.FullName -eq $nugetCoreName.FullName}

Add-Type -ReferencedAssemblies $nugetCore -TypeDefinition @"
    public class CustomPathResolver : NuGet.DefaultPackagePathResolver
    {
        public CustomPathResolver(string path) :base(path) {}

        public override string GetPackageDirectory(string packageId, NuGet.SemanticVersion version)
        {
            return "";
        }
    }

"@
