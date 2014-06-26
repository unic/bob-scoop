Function Publish-ScSerializationPackage
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        [Parameter(Mandatory=$true)]
        [string]$Mode,
        [string]$Source,
        [string]$Targets,
        [string]$Languages
    
	)
    Begin{}
    
    Process
    {
        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        $scriptPath = Split-Path $scriptInvocation.MyCommand.Definition -Parent

        $params = @();
        $params += "$url/services/publish/$Mode"
        
        $params += "--data"
        $data = @();

        if($Source) {
            $data += "source=$Source"
        }
        if($Targets) {
            $data += "targets=$Targets"
        }
        if($Languages) {
            $data += "languages=$Languages"
        }

        $params += [string]::Join($data, "&");
        
        $process = Start-Process "$scriptPath\..\..\..\tools\curl\curl.exe" $params -RedirectStandardOutput "$($env:TEMP)\install-serializationPackage-std.txt" -RedirectStandardError "$($env:TEMP)\install-serializationPackage-error.txt" -NoNewWindow  -Wait -PassThru
        if($process.ExitCode -eq 0) {
            Get-Content "$($env:TEMP)\install-serializationPackage-std.txt"
            Write-Host "Publish SerializationPackage with API-Url '$("$url/services/publish/$Mode")'  " -ForegroundColor Green;
        }
        else {
            Write-Error ("Install SerializationPackage $Path with API-Url '$("$url/services/package/install/fileupload") failed`n"+     (Get-Content "$($env:TEMP)\install-serializationPackage-error.txt"))
        
            exit
        }
    }
}