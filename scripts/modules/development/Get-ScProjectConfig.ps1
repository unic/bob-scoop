<#
.SYNOPSIS
Reads the BOB configuration file and returns it as XML-Object.
.DESCRIPTION
Reads the BOB configuration file and returns it as XML-Object. 
Per default the config file is taken from the App_Config/Bob.config file in the current Visual Studio project.

.PARAMETER ProjectPath
The path of the project for which the config shoud be readed.
.PARAMETER ConfigFilePath
The folder in which the config file is located. The path must be relative to the project path.
.PARAMETER ConfigFileName
The filename of the config file.

.EXAMPLE
Get-ScProjectConfig
.EXAMPLE
Get-ScProjectConfig -ProjectPath D:\projects\Spider\src\Spider.Website -ConfigFilePath App_Config -ConfigFileName Bob.config
#>

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