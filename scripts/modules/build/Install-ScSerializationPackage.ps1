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


