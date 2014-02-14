<# 
.SYNOPSIS 
    NOT USED BY BOB!
    ----------------
    Traverses directories, starting with the project directory, testing for a RootIdentifier.
.DESCRIPTION 
    Not used at the moment as Bob.config has been moved to project specific /App_Config folder!
.NOTES 
    Author     :  Unic AG
.LINK 
    http://sitecore.unic.com
#>
Function Get-ScProjectRootPath
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$ProjectPath = "",
        [String]$RootIdentifier = "Misc"
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

        $currentPath = Get-Item $projectPath
        
        while (-not (Get-ChildItem $currentPath -Directory | Where-Object {$_.Name -eq $RootIdentifier}) -and ($currentPath.Name.Length -gt 3))
        {    
            $currentPath = Get-Item (Split-Path $currentPath.FullName -Parent)
        }
        
        if($currentPath.Name.Length -le 3) {
            throw "No ProjectRootPath found based on $RootIdentifier. Please check if $RootIdentifier is correct."
        }
        
        return $currentPath

    }
}