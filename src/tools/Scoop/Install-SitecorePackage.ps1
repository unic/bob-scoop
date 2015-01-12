<#
.SYNOPSIS
Installs the correct Sitecore distribution to a specific location.
.DESCRIPTION
Install-SitecorePackage installs the  correct Sitecore distribution to a specific location.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website proje

.PARAMETER OutputLocation
The location where to extract the Sitecore distribution

.EXAMPLE
Install-SitecorePackage -OutputLocation D:\Web\Magic

#>
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
                Write-Verbose "Install Sitecore.Distribution.$type $($package.Version)"
                $packageManager.InstallPackage("Sitecore.Distribution.$type", $($package.Version) )
                $installed = $true
            }
            $i++;
        }
    }
}

if($dte) {
  $nugetCoreName = [NuGet.VisualStudio.ServiceLocator].Assembly.GetReferencedAssemblies() | ? {$_.Name -eq "NuGet.Core"}
  $nugetCore = [AppDomain]::CurrentDomain.GetAssemblies() | ? {$_.FullName -eq $nugetCoreName.FullName}
  try
  {
    [CustomPathResolver] | Out-null
  }
  catch
  {
    #Type CustomPathResolver does not exists
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
  }
}
