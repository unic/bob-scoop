<#
.SYNOPSIS
Installs a .dacpac file

.DESCRIPTION
Installs a .dacpac file on the specified server with the defined database name.

.EXAMPLE
Install-DataTierApplication "c:\temp\Sitecore.Master.dacpac" "sitecore_master"

#>
function Install-DataTierApplication
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]        
        [string] $DacPacPath,
        [Parameter(Mandatory = $true)]        
        [string] $DatabaseName,
        [string] $ServerName = "localhost",
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        $sqlPackagePath = $config.SqlPackagePath

        if(-not (Test-Path $sqlPackagePath)){
            throw "Invalid path to SqlPackage.exe ($sqlPackagePath)"
        }

        & "$sqlPackagePath" `
            /Action:Publish `
            /SourceFile:$DacPacPath `
            /TargetServerName:$ServerName `
            /TargetDatabaseName:$DatabaseName
    }
}
