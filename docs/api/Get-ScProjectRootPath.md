

# Get-ScProjectRootPath

Traverses directories, starting with the project directory, testing for a RootIdentifier.

## Syntax

    Get-ScProjectRootPath [[-ProjectPath] <String>] [[-RootIdentifier] <String>] [[-stopString] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Traverses directories upwards, starting with the project directory,
testing if the folder contains a folder with name of RootIdentifier which is misc per defaualt.





## Parameters

    
    -ProjectPath <String>

The path where to start with searching. If none is provided the path of the current Visual Studio Project is taken.





Required?  false

Position? 1

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -RootIdentifier <String>

The folder name which the project path must contain.





Required?  false

Position? 2

Default value? misc

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -stopString <String>

Specifies until which folder the function should search the project root path.





Required?  false

Position? 3

Default value? :

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -WhatIf <SwitchParameter>

Required?  false

Position? named

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -Confirm <SwitchParameter>

Required?  false

Position? named

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Get-ScProjectRootPath

Get-ScProjectRootPath





























