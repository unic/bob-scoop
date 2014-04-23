Function Get-ScProjectConfig
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$ProjectPath = "",
        [String]$ConfigFilePath = "App_Config",
        [String]$ConfigFileName = "Bob.config"
    )
    Begin{}

    Process
    {
        if(-not $ProjectPath -and (Get-Command | ? {$_.Name -eq "Get-Project"})) {
            $project = Get-Project 
            if($Project) {
                $ProjectPath = Split-Path $project.FullName -Parent
            }
        }

        if(-not $ProjectPath) {
            throw "No ProjectPath could be found. Please provide one."
        }
        
        $path = Join-Path (Join-Path $ProjectPath "$ConfigFilePath") "$ConfigFileName"
        if(Test-Path $path) {
            return ([xml](Get-Content $path)).Configuration
        }
        else {
            throw "No Config-File could be found at $path";
        }
    }
}