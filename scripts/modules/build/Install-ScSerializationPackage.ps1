<#
.SYNOPSIS
Installs a Sitecore Package with Sitecore Ship
.DESCRIPTION
This command can be used to install a Sitecore package with the help of Sitecore Ship by specifying the location of an update package file to upload to the server. Optionaly a Publish job will be triggered after the installation.
.PARAMETER Path
The Path to the Sitecore update pacakge
.PARAMETER Url
The Base-Url of the Sitecore Environment to install the package.
.PARAMETER PackageId
If recordInstallationHistory  is enabled you have to provide this parameter.
.PARAMETER Description
If recordInstallationHistory  is enabled you have to provide this parameter.
.PARAMETER Publish
If this switch is added a publish jobb will be triggered after the package install
.PARAMETER PublishMode
Must be one of the following values: 
 - full
 - smart
 - incremental

.PARAMETER PublishSource
Detault is master
.PARAMETER PublishTargets
Default is web
.PARAMETER PublishLanugages
Default is en
.EXAMPLE
Install-ScSerializationPackage -Path D:\Deployment\64-items.update -Url http://local.post.ch
#>
Function Install-ScSerializationPackage
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [Parameter(Mandatory=$true)]
		[String]$Path,
        [Parameter(Mandatory=$true)]
		[String]$Url,
        [bool]$DisableIndexing=$false,
        [String]$PackageId,
        [String]$Description,
        [switch]$Publish,
        [string]$PublishMode,
        [string]$PublishSource,
        [string]$PublishTargets,
        [string]$PublishLanugages
    
	)
    Begin{}

    Process
    {
        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        $scriptPath = Split-Path $scriptInvocation.MyCommand.Definition -Parent
		
        $Path = (Resolve-Path $Path).Path

        $params = @();
        $params += "$url/services/package/install/fileupload"
        $params += "-F"
        $params += "file=@$Path"
        $params += "-F"
        $params += "DisableIndexing=$DisableIndexing"

        if($PackageId) {
            $params += "-F";
            $params += "PackageId=$PackageId"
        }
        if($Description) {
            $params += "-F";
            $params += "Description=$Description"
        }

        $process = Start-Process "$scriptPath\..\..\..\tools\curl\curl.exe" $params -RedirectStandardOutput "$($env:TEMP)\install-serializationPackage-std.txt" -RedirectStandardError "$($env:TEMP)\install-serializationPackage-error.txt" -NoNewWindow  -Wait -PassThru
        
        $logPath = "$((Resolve-Path $Path).Path).log"
        cp "$($env:TEMP)\install-serializationPackage-std.txt" $logPath
        if($process.ExitCode -eq 0) {
            Write-Host "Installed SerializationPackage $Path with API-Url '$("$url/services/package/install/fileupload")'  "            
            Write-Host "The log was written at $logPath"
            
        }
        else {
            Write-Error ("Install SerializationPackage $Path with API-Url '$("$url/services/package/install/fileupload") failed`n" + (Get-Content "$($env:TEMP)\install-serializationPackage-error.txt"))
        
            exit
        }
        if($Publish) {
            if(-not $PublishMode) {
                throw "You have to provide the parameter 'PublishMode'"
            }
            Publish-ScSerializationPackage -Url $Url -Mode $PublishMode -Source $PublishSource -Targets $PublishTargets -Lanugages $PublishLanugages
        }
    }

    End{}
}


