<# 
.SYNOPSIS 
    Traverses directories, starting with the project directory, testing for a RootIdentifier.
.DESCRIPTION 
    Traverses directories upwards, starting with the project directory, 
	testing if the folder contains a folder with name of RootIdentifier which is misc per defaualt.
.PARAMETER ProjectPath
The path where to start with searching. If none is provided the path of the current Visual Studio Project is taken.
.PARAMETER RootIdentifier
The folder name which the project path must contain.
.PARAMETER stopString
Specifies until which folder the function should search the project root path.
.EXAMPLE
Get-ScProjectRootPath
#>
Function Get-ScProjectRootPath
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
        [String]$ProjectPath = "",
        [String]$RootIdentifier = "misc",
        [String]$stopString = ":"
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
        
        while (-not (Get-ChildItem $currentPath | Where-Object {$_.Name -eq $RootIdentifier}) -and (-not $currentPath.Name.Contains($stopString)))
        {    
            $currentPath = Get-Item (Split-Path $currentPath.FullName -Parent)
        }
        
        if($currentPath.Name.Contains($stopString)) {
            throw "No ProjectRootPath found based on $RootIdentifier. Please check if $RootIdentifier is correct."
        }
        
        return $currentPath

    }
}