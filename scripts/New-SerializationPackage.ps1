Function New-SerializationPackage
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

        & "$scriptPath\..\tools\sitecore-courier\Sitecore.Courier.Runner.exe" /source:$Source /target:$Target /output:$OutputFile
    }
}