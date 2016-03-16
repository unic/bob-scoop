<#


#>
function Install-SitecorePackage
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath
        $ProjectPath = $config.ProjectPath 
    }
}
