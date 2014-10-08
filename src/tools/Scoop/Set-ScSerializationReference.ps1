<#
.SYNOPSIS
Sets the SerializationReference path of the current project.
.DESCRIPTION
Creates or edits the serialization reference configuration path in the local IIS web path to a specific directory in the project root directory.
This configuration is used by Sitecore to know where items should be automaticaly serialized.

.PARAMETER ProjectRootPath
The root path of the project where the sereialization folder is located.
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
        [String]$ProjectRootPath = "",
        [String]$WebPath = ""
    )
    Begin{}

    Process
    {
        if(-not $ProjectRootPath -and (Get-Command | ? {$_.Name -eq "Get-ScProjectRootPath"})) {
            $ProjectRootPath = Get-ScProjectRootPath
        }

        if(-not $ProjectRootPath) {
            throw "ProjectRootPath not found. Please provide one."
        }
        $localSetupConfig = Get-ScProjectConfig

        if(-not $localSetupConfig.SerializationReferenceTemplate) {
          Write-Error "The configuration SerializationReferenceTemplate could not be found in Bob.config"
          exit
        }


        if(-not $WebPath) {
            if($localSetupConfig.GlobalWebPath -and $localSetupConfig.WebsiteCodeName) {
                if(-not (Test-Path $localSetupConfig.GlobalWebPath)) {
                    Write-Error "The GlobalWebPath '$($localSetupConfig.GlobalWebPath)' does not exist. Please specify a correct path in Bob.config"
                    exit
                }
                $webSitePath = Join-Path  $localSetupConfig.GlobalWebPath $localSetupConfig.WebsiteCodeName
                if(-not (Test-Path $webSitePath)) {
                    Write-Error "The path of the Website '$webSitePath' does not exist. Please specify correct values in Bob.config"
                    exit
                }
                $WebPath = Join-Path  $webSitePath $localSetupConfig.WebFolderName
                if(-not (Test-Path $WebPath)) {
                    Write-Error "The path of the Web-Folder '$WebPath' does not exist. Please specify correct values in Bob.config"
                    exit
                }
            }
            else {
                Write-Error "GlobalWebPath or WebsiteCodeName are not valid in Bob.config. Please configure this values."
                exit
            }
        }

        if(-not $WebPath) {
            Write-Error "WebPath not found. Please provide one."
            exit
        }

        $SerializationFolderName = $localSetupConfig.SerializationFolder
        $configFilePath = $localSetupConfig.SerializationReferenceFilePath
        if(-not $configFilePath) {
            Write-Error "No SerializationReferenceFilePath was specified in Bob.config. Please provide a value for SerializationReferenceFilePath."
            exit
        }

       Write-Verbose "Start  Set-ScSerializationReference with params:  -WebPath '$WebPath' -ProjectRootPath '$ProjectRootPath' ";

       $serializationPath = Join-Path $ProjectRootPath $SerializationFolderName;


       $elementValue = (Join-Path $ProjectRootPath $SerializationFolderName).ToString()

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

       if(-not $config) {
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
        Write-Verbose "End  Set-ScSerializationReference with params:  -WebPath '$WebPath' -ProjectRootPath '$ProjectRootPath' ";
    }

    End{}
}
