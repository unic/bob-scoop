$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Update-ScDatabase" {

    function Get-Project {
        return @(@{"FullName" = "$TestDrive\MyProject.csproj"; "ProjectName" = "MyProj"})
    }

    function Get-Package {
        return @(
            @{"Id" = "Package1"; "DependencySets" = @(@{"Dependencies"= @{"Id" = "Sitecore"}})},
            @{"Id" = "Package2"}
        )
    }

    function Update-Package {param($Id, $ProjectName, $Version)}

    Context "when an update is done." {
        $targetVersion = "6.5.12345.90"
        Mock Update-Package {} -Verifiable -ParameterFilter {$Id -eq "Package1" -and $ProjectName -eq "MyProj" -and $Version -eq $targetVersion}


        $packagesConfig = @"
<?xml version="1.0" encoding="utf-8"?>
<packages>
    <package id="Sitecore" version="6.5.120706.84" targetFramework="net40" allowedVersions="[6.5.120706.84]" />
</packages>
"@

        $file = "TestDrive:\packages.config"
        $packagesConfig |  Out-File $file -Encoding UTF8

        Update-Sitecore $targetVersion

        [xml]$newConfig = Get-Content $file

        It "Should set the new allowedVersion" {
            ($newConfig.packages.package | ? {$_.id -eq "Sitecore"}).allowedVersions | Should Be "[6.5.12345.90]"
        }

        It  "Should have udpated the packages" {
            Assert-VerifiableMocks
        }
    }
}
