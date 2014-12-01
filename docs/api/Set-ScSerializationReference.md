

# Set-ScSerializationReference

Sets the SerializationReference path of the current project.

## Syntax

    Set-ScSerializationReference [[-ProjectRootPath] <String>] [[-WebPath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Creates or edits the serialization reference configuration path in the local IIS web path to a specific directory in the project root directory.
This configuration is used by Sitecore to know where items should be automaticaly serialized.





## Parameters

    
    -ProjectRootPath <String>

The root path of the project where the sereialization folder is located.





Required?  false

Position? 1

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -WebPath <String>

The Web-Folder of the IIS Site.





Required?  false

Position? 2

Default value? 

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
    Set-ScSerializationReference































