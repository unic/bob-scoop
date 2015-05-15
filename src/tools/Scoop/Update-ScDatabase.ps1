<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

#>
function Update-ScDatabase
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
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
