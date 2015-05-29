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
        $statusFile = "$($env:TEMP)\$([GUID]::NewGuid())"
        $returnFile = "$($env:TEMP)\$([GUID]::NewGuid())"
        "" | Out-File $returnFile -Encoding UTF8
        $errorFile = "$($env:TEMP)\$([GUID]::NewGuid())"

        $params = @();
        $params += "$url/services/package/install/fileupload"
        $params += "-F"
        $params += "file=""@$Path"""
        $params += "-F"
        $params += "DisableIndexing=$DisableIndexing"
        $params += "-k"
        $params += "-o"
        $params += "$returnFile"
        $params += "-w"
        $params +=  """%{http_code}"""

        if($PackageId) {
            $params += "-F";
            $params += "PackageId=$PackageId"
        }
        if($Description) {
            $params += "-F";
            $params += "Description=$Description"
        }

        $process = Start-Process (ResolvePath "curl" "tools\curl.exe") $params -RedirectStandardOutput $statusFile -RedirectStandardError $errorFile -NoNewWindow  -Wait -PassThru

        $logPath = "$((Resolve-Path $Path).Path).log"
        $errorLogPath = "$((Resolve-Path $Path).Path).error.log"
        cp $returnFile $logPath
        cp $errorFile $errorLogPath

        $status = (Get-Content $statusFile)
        if($process.ExitCode -eq 0 -and $status -ge 200 -and $status -lt 400) {
            Write-Host "Installed SerializationPackage:  $Path with API-Url '$("$url/services/package/install/fileupload") "
            Write-Host (Get-Content $returnFile )

        }
        else {
            Write-Error ("Install SerializationPackage $Path with API-Url '$("$url/services/package/install/fileupload") failed`n" + (Get-Content $errorFile) + "`n" + (Get-Content $returnFile))

            return
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
