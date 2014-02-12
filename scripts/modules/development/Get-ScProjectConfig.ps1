Function Get-ScProjectConfig
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$ProjectRootPath = "",
        [String]$ConfigFilePath = "Misc",
        [String]$ConfigFileName = "Bob.xml"
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
        
        $path = Join-Path (Join-Path $ProjectRootPath "$ConfigFilePath") "$ConfigFileName"
        if(Test-Path $path) {
            return ([xml](Get-Content $path)).Configuration
        }
        else {
            throw "No Config-File could be found at $path";
        }
    }
}