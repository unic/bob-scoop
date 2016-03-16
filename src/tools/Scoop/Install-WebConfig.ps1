<#


#>
function Install-WebConfig
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath,
        [string] $Environment = "local",
        [string] $role = "author"
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        $ProjectPath = $config.WebsitePath 
        $scContext = Get-ScContextInfo $ProjectPath
    
        $type = $scContext.Type
        $configPath = Install-NugetPackageToCache -Version $scContext.Version -PackageId "Sitecore.$type.Config" -ProjectPath $ProjectPath
        $baseWebconfig = "$configPath\content\Web.config"
        
        $xdtDll = ResolvePath -PackageId "Microsoft.Web.Xdt" -RelativePath "lib\net40\Microsoft.Web.XmlTransform.dll"
        [System.Reflection.Assembly]::LoadFile($xdtDll) | Out-Null

        $document = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument
        $document.PreserveWhitespace = $true
        $document.Load($baseWebconfig)

        $webConfigs = @("Web.base.config", "Web.$role.config", "Web.$environment.config", "Web.$environment.$role.config")
        $projects = (ls $ProjectPath -Include *.csproj -Recurse)
        
        foreach($webConfig in $webConfigs) {
            foreach($project in  $projects){
                $projectFolder = Split-path $project
                
                $xdtPath = "$projectFolder\$webConfig"
                if(Test-Path $xdtPath) {
                    $transform = New-Object Microsoft.Web.XmlTransform.XmlTransformation $XdtPath
                    $transform.Apply($document) | Out-Null
                    Write-Verbose "Applied transform $xdtPath"
                }
            }
        }
        
        $webRoot = $config.WebRoot
        $webConfigPath = "$webRoot\Web.config"
        $document.Save($webConfigPath)
        Write-Verbose "Saved Web.config to $webConfigPath"
    }
}
