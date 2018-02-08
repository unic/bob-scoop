

# Get-ScScratchProjectConfig

Reads the configuration files required for Scratch and returns it as a hashtable
## Syntax

    Get-ScScratchProjectConfig [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Reads the configuration files and returns it as a hashtable. Priority will be given to Bob.config and Bob.config.user
If no Bob.config(.user) is found, the Installation.config(.user) will be used.
Per default the config file is taken from the the first config that we come across going from where we are upwards.





## Parameters

    
    -ProjectPath <String>
_The path of the project for which the config should be read.
If not provided the current Visual Studio project or the *.Website project will be used._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Get-ScScratchProjectConfig






























### -------------------------- EXAMPLE 2 --------------------------
    Get-ScScratchProjectConfig -ProjectPath D:\projects\Spider\src\Spider.Website































