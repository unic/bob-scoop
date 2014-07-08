<#
.SYNOPSIS
Builds a Sitecore Update packages automatically with the help of Sitecore Courier, by analyzing two Sitecore packages and packaging only changed items.
.DESCRIPTION
Builds a Sitecore Update packages automatically with the help of Sitecore Courier, by analyzing two Sitecore packages and packaging only changed items.
.PARAMETER Source
Path, which should point to the baseline serialization folder (this is the older version of the serialized item tree). If this path points to an empty folder, an update package with all serialized items in the target folder will be generated
The path must be either absolute or relative to the current working directory.
.PARAMETER Target
Path, which should point to the latest (target) version of the serialized folder.
The path must be either absolute or relative to the current working directory.

.PARAMETER OutputFile
The file wheree the Update Package should be written to
.EXAMPLE
New-ScSerializationPackage -Source D:\sourceSerialization -Target D:\targetSerialization -OutputFile D:\package.update
#>
Function New-ScSerializationPackage
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Source,
        [Parameter(Mandatory=$true)]
        [string]$Target,
        [Parameter(Mandatory=$true)]
        [string]$OutputFile
    
	)
    Begin{}
    
    Process
    {
        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        $scriptPath = Split-Path $scriptInvocation.MyCommand.Definition -Parent

        $Source = (Resolve-Path $Source -ErrorAction Stop).Path
        $Target = (Resolve-Path $Target -ErrorAction Stop).Path

        if(-not [System.IO.Path]::IsPathRooted($OutputFile)) {
            $OutputFile = Join-Path $PWD $OutputFile
        }

        & "$scriptPath\..\..\..\tools\sitecore-courier\Sitecore.Courier.Runner.exe" /source:$Source /target:$Target /output:$OutputFile
    }
}