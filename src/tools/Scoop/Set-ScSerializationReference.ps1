<#
.SYNOPSIS
Sets the SerializationReference path of the current project.
.DESCRIPTION
Creates or edits the serialization reference configuration path in the local IIS web path to a configured directoy in Bob.config.
This configuration is used by Sitecore to know where items should be automaticaly serialized.

.PARAMETER WebPath
The Web-Folder of the IIS Site.

.EXAMPLE
Set-ScSerializationReference

#>
Function Set-ScSerializationReference
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$WebPath = "",
        [string]$ProjectPath,
        [string]$SerializationPath,
        [string]$SerializationTemplateKey = "SerializationReferenceTemplate"
    )

    Process
    {
        $localSetupConfig = Get-ScProjectConfig $ProjectPath

        if(-not $localSetupConfig[$SerializationTemplateKey]) {
          Write-Error "The configuration $SerializationTemplateKey could not be found in Bob.config"
          exit
        }

        if(-not $WebPath) {
            $WebPath = $localSetupConfig.WebRoot
        }

        if(-not $WebPath) {
            Write-Error "WebRoot not found. Please provide one."
            exit
        }

        $configFilePath = $localSetupConfig.SerializationReferenceFilePath
        if(-not $configFilePath) {
            Write-Error "No SerializationReferenceFilePath was specified in Bob.config. Please provide a value for SerializationReferenceFilePath."
            exit
        }

        Write-Verbose "Start  Set-ScSerializationReference with params:  -WebPath '$WebPath' "

        if(-not $SerializationPath) {
            $SerializationPath = Join-Path $localSetupConfig.WebsitePath $localSetupConfig.SerializationPath
        }
        if(-not (Test-Path $SerializationPath)) {
            mkdir $SerializationPath | Out-Null
        }
        $elementValue = (Resolve-Path $SerializationPath).Path

        $configPath = Join-Path $WebPath $configFilePath ;
        if(-not (Test-Path $configPath)) {
            $configFileDirecotry = Split-Path $configPath
            if($configFileDirecotry -and -not (Test-Path $configFileDirecotry) ){
                mkdir $configFileDirecotry | Out-Null
            }
        }
        else {
           rm $configPath
        }

        $config = $localSetupConfig[$SerializationTemplateKey]

        $config.Replace("[BobSerializationPath]", $elementValue) | Out-File $configPath -Encoding unicode
        Write-Host "Set serialization reference in '$configPath' to $elementValue"
        Write-Verbose "End  Set-ScSerializationReference with params:  -WebPath '$WebPath'  ";
    }
}
