Function Set-ScSerializationReference
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
		[String]$ProjectPath = "",
		[String]$WebPath = ""
	)
    Begin{}

    Process
    {
		if(-not $ProjectPath -and (Get-Command | ? {$_.Name -eq "Get-Project"})) {
			$project = Get-Project 

			$ProjectPath = Split-Path (Split-Path $project.FullName -Parent) -Parent
		}

		if(-not $ProjectPath) {
			throw "ProjectPath not found. Please provide one."
		}
        
        $localSetupConfig = Get-ProjectConfig $ProjectPath "LocalSetup"


		if(-not $WebPath) {
            if($localSetupConfig.GlobalWebPath -and $localSetupConfig.WebsiteCodeName) {
			    $WebPath = Join-Path (Join-Path  $localSetupConfig.GlobalWebPath ($localSetupConfig.WebsiteCodeName)) $localSetupConfig.WebFolderName
            }

		}

		if(-not $WebPath) {
			throw "WebPath not found. Please provide one."
		}
        
        $SerializationFolderName = $localSetupConfig.SerializationFolder
        $configFilePath = $localSetupConfig.SerializationReferenceFilePath

       Write-Verbose "Start  Set-ScSerializationReference with params:  -WebPath '$WebPath' -ProjectPath '$ProjectPath' ";

       $serializationPath = Join-Path $ProjectPath $SerializationFolderName;

	   $elementValue = (Join-Path $ProjectPath $SerializationFolderName).ToString()

       $configPath = Join-Path $WebPath $configFilePath ;


       if(Test-Path $configPath){
        [XML]$config = Get-Content $configPath
       }

       if(-not $config) {
            $config = [xml]$localSetupConfig.SerializationReferenceTemplate.InnerText
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
       Write-Verbose "End  Set-ScSerializationReference with params:  -WebPath '$WebPath' -ProjectPath '$ProjectPath' ";



    }

    End{}
}
