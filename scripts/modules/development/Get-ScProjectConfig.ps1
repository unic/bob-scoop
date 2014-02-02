Function Get-ScProjectConfig
{
    [CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
		[String]$ProjectPath = "",
        [String]$ConfigName = ""
	)
    Begin{}

    Process
    {
        if(-not $ProjectPath -and (Get-Command | ? {$_.Name -eq "Get-Project"})) {
			$project = Get-Project 
            if($Project) {
			    $ProjectPath = Split-Path (Split-Path $project.FullName -Parent) -Parent
            }
		}

        if(-not $ProjectPath) {
            throw "No ProjectPath could be found. Please provide one."
        }

        $path = Join-Path (Join-Path $ProjectPath "Misc" ) "$ConfigName.xml"
        if(Test-Path $path) {
            return ([xml](Get-Content $path)).Configuration
        }
        else {
            throw "No Config-File could be found at $path";
        }
    }
}