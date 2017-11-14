

# Merge-ConnectionStrings

Creates a ConnectionStrings.config by merging the file from the project and Bob.config.
## Syntax

    Merge-ConnectionStrings [-OutputLocation] <String> [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Merge-ConnectionStrings reads the connectionStrings.config in the Website project
and replaces all SQL server/instance names with the value from the Bob.config.
The resulting file will then be written to a specified location.





## Parameters

    
    -OutputLocation <String>
_The file path where to write the resulting connectionStrings.config_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Merge-ConnectionStrings D:\Webs\Magic\connectionStrings.config































