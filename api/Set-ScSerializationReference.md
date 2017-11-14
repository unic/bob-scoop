

# Set-ScSerializationReference

Sets the SerializationReference path of the current project.
## Syntax

    Set-ScSerializationReference [[-WebPath] <String>] [[-ProjectPath] <String>] [[-SerializationPath] <String>] [[-SerializationTemplateKey] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Creates or edits the serialization reference configuration path in the local IIS web path to a configured directoy in Bob.config.
This configuration is used by Sitecore to know where items should be automaticaly serialized.





## Parameters

    
    -WebPath <String>
_The Web-Folder of the IIS Site._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    
    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    
    
    -SerializationPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false |  | false | false |


----

    
    
    -SerializationTemplateKey <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | false | SerializationReferenceTemplate | false | false |


----

    
    
    -WhatIf <SwitchParameter>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false |  | false | false |


----

    
    
    -Confirm <SwitchParameter>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Set-ScSerializationReference































