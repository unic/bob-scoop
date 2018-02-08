

# Install-DataTierApplication

Installs a .dacpac file
## Syntax

    Install-DataTierApplication [-DacPacPath] <String> [-DatabaseName] <String> [[-ServerName] <String>] [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Installs a .dacpac file on the specified server with the defined database name.





## Parameters

    
    -DacPacPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -DatabaseName <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    
    
    -ServerName <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false | localhost | false | false |


----

    
    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-DataTierApplication "c:\temp\Sitecore.Master.dacpac" "sitecore_master"































