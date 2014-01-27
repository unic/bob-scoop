Function Publish-SerializationPackage
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
        [string]$Lanugages
    
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
        if($Lanugages) {
            $data += "languages=$Lanugages"
        }

        $params += [string]::Join($data, "&");
        
        Start-Process "$scriptPath\..\lib\curl\curl.exe" $params -RedirectStandardOutput "$($env:TEMP)\install-serializationPackage-std.txt" -RedirectStandardError "$($env:TEMP)\install-serializationPackage-error.txt" -NoNewWindow  -Wait
        Get-Content "$($env:TEMP)\install-serializationPackage-std.txt"
    }
}