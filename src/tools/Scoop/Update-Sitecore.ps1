<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

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
    }
}
