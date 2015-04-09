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
        [string] $ProjectPath
    )
    Begin{}

    Process
    {
        $localSetupConfig = Get-ScProjectConfig $ProjectPath

        if(-not $localSetupConfig.SerializationReferenceTemplate) {
          Write-Error "The configuration SerializationReferenceTemplate could not be found in Bob.config"
          exit
        }

        if(-not $WebPath) {
            $WebPath = $localSetupConfig.WebRoot
        }

        if(-not $WebPath) {
            Write-Error "WebRoot not found. Please provide one."
            exit
        }

        $serializationPath = $localSetupConfig.SerializationPath
        $configFilePath = $localSetupConfig.SerializationReferenceFilePath
        if(-not $configFilePath) {
            Write-Error "No SerializationReferenceFilePath was specified in Bob.config. Please provide a value for SerializationReferenceFilePath."
            exit
        }

       Write-Verbose "Start  Set-ScSerializationReference with params:  -WebPath '$WebPath' "

       $Path = Join-Path $localSetupConfig.WebsitePath $serializationPath
       if(-not (Test-Path $Path)) {
            mkdir $Path | Out-Null
       }
       $elementValue = (Resolve-Path $Path).Path

       $configPath = Join-Path $WebPath $configFilePath ;
       if(-not (Test-Path $configPath)) {
            $configFileDirecotry = Split-Path $configPath
            if($configFileDirecotry -and -not (Test-Path $configFileDirecotry) ){
                mkdir $configFileDirecotry | Out-Null
            }
       }


        if(Test-Path $configPath){
            [XML]$config = Get-Content $configPath
        }
        else {
            $config = [xml]$localSetupConfig.SerializationReferenceTemplate
        }

        $serializationNodePath = $localSetupConfig.SerializationReferenceXPath

        $nsManager = new-object System.Xml.XmlNamespaceManager $config.NameTable
        $nsManager.AddNamespace("set", "http://www.sitecore.net/xmlconfig/set/");

        $node = $config.SelectSingleNode($serializationNodePath, $nsManager)

        if(-not $node){
            $currentNodePath = "";
            $nodeNames =   $serializationNodePath.Split('/');
            $parentNode = $config
            foreach($nodeName in $nodeNames ) {
                $currentNodePath += "/" + $nodeName
                $node = $config.SelectSingleNode($currentNodePath, $nsManager)

                if(-not $nodeName.StartsWith("@")) {
                    if(-not $node) {
                        $newNode = $config.CreateElement($nodeName)
                        $parentNode.AppendChild($newNode) | Out-Null;
                        $node = $config.SelectSingleNode($currentNodePath, $nsManager)
                    }
                }

                $parentNode = $node
            }
        }


        $node.InnerText = $elementValue

      $config.Save($configPath);
        Write-Host "Set serialization reference in '$configPath' to $elementValue"
        Write-Verbose "End  Set-ScSerializationReference with params:  -WebPath '$WebPath'  ";
    }

    End{}
}
