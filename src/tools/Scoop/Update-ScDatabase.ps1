<#
.SYNOPSIS
Installs the Sitecore update package of the currently installed Sitecore version.

.DESCRIPTION
Downloads the Sitecore.Update NuGet package of the
currently installed Sitecore version and installs the update package 
to the local database.

.PARAMETER ProjectPath
The path to the project for which the database should be updated.

.EXAMPLE

#>
function Update-ScDatabase
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        Invoke-BobCommand {
            $config = Get-ScProjectConfig $ProjectPath
            $context = Get-ScContextInfo $ProjectPath

            $tempLocation = "$($env:TEMP)\$([Guid]::NewGuid())"
            mkdir $tempLocation | Out-Null
            Install-NugetPackage -PackageId Sitecore.Update -Version $context.version -ProjectPath $ProjectPath -OutputLocation $tempLocation

            if((-not ($config.IISBindings)) -or ($config.IISBindings.Count -eq 0)) {
                Write-Error "No IIS bindings could be found."
            }
            $baseUrl = $config.IISBindings[0].InnerText

            Install-ScSerializationPackage -Path (ls $tempLocation).FullName -Url $baseUrl

            rm $tempLocation -Recurse
        }
    }
}
