<#
.SYNOPSIS
Transforms all Web.*.config with the Sitecore web.config and puts it to the web-root.

.DESCRIPTION
Transforms all Web.*.config of all projects in the repo
with the Sitecore web.config and puts it to the web-root.

.PARAMETER ProjectPath
The project path containing the Sitecore configuration.

.PARAMETER Environment
The environment for which the web-configs should be transformed.

.PARAMETER Role
The role for which the web-configs should be transformed.

.PARAMETER AdditionalXdtFiles
A list of additional XDT files which should be applied to the Web.config at the end of the process.

.EXAMPLE
Install-WebConfigByFolders -Folders @(".\Website") -ConfigPath "." -AdditionalXdtFiles @("C:\template\Web.config.xdt")

#>
function Install-WebConfigByFolders
{
    [CmdletBinding()]
    Param(
        [string[]] $Folders,
        [string] $ConfigPath,
        [string] $Environment = "local",
        [string[]] $Role = @("author"),
        [string[]] $AdditionalXdtFiles = @()
    )
    Process
    {        
        $xdtDll = ResolvePath -PackageId "Microsoft.Web.Xdt" -RelativePath "lib\net40\Microsoft.Web.XmlTransform.dll"
        [System.Reflection.Assembly]::LoadFile($xdtDll) | Out-Null

        $document = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument
        $document.PreserveWhitespace = $true
        $document.Load($ConfigPath)

        $webConfigs = Get-RubblePattern  'Web.base.config;Web.$role.config;Web.$environment.config;Web.$environment.$role.config'  @{'$role' = $Role; '$environment' = $Environment}
            
        foreach($folder in  $Folders){
            foreach($webConfig in $webConfigs) {
                $xdtFile = "$folder\$webConfig"
                ApplyTransformation $document $xdtFile
            }
        }

        foreach($xdtFile in $AdditionalXdtFiles) {
            ApplyTransformation $document $xdtFile
        }

        $document.Save($ConfigPath)
        Write-Verbose "Saved Web.config to $ConfigPath"
    }
    Begin
    {
        function ApplyTransformation($document, $xdtFile) {
            if(Test-Path $xdtFile) {
                $transform = New-Object Microsoft.Web.XmlTransform.XmlTransformation $xdtFile
                $transform.Apply($document) | Out-Null
                Write-Verbose "Applied transform $xdtFile"
            }
        }
    }
}
