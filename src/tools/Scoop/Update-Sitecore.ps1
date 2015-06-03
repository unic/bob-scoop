<#
.SYNOPSIS
Updates all NuGet packages of Sitecore to a new version.

.DESCRIPTION
Sets the allowedVersions attribute of the Sitecore package in packages.config
of all projects to the new version. Then it updates every package referencing the
Sitecore package to the new version.


.PARAMETER Version
The version to update to.

.EXAMPLE
Update-Sitecore -Version 7.2.12345.56

#>
function Update-Sitecore
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Version
    )
    Process
    {
        $projects = Get-Project -All
        foreach($project in $projects) {
            $folder = Split-Path $project.FullName
            $file = "$folder\packages.config"
            if(Test-Path $file) {
                [xml]$packagesConfig = Get-Content $file
                $sitecore = $packagesConfig.packages.package | ? {$_.id -eq "Sitecore"}
                if($sitecore) {
                    $sitecore.SetAttribute("allowedVersions", "[$Version]")
                }
                $packagesConfig.Save($file)

                $packages = Get-Package -ProjectName $project.ProjectName

                $packages | ? {$_.DependencySets.Dependencies | ? {$_.Id -eq "Sitecore"}} | % {
                    Update-Package -Id $_.Id -ProjectName $project.ProjectName -Version $Version
                }
            }
        }

        $dte.ItemOperations.OpenFile("$PSScriptRoot\..\SitecoreUpdateManualActions.txt", [EnvDTE.Constants]::vsext_vk_TextView) | Out-Null
    }
}
