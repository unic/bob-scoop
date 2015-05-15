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


            Write-Host $tempLocation
            #rm $tempLocation -Recurse
        }
    }
}
