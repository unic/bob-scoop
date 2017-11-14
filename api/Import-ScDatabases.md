

# Import-ScDatabases

Restores all databases of a project from a file share.
## Syntax

    Import-ScDatabases [[-ProjectPath] <String>] [[-DatabasePath] <String>] [-IncludeWebDatabase] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Restores all databases which are referenced in the ConnectionStrings file of the project to the local database server.
The backup will be copied to the C:\Temp directory before restoring it.
The location of the backups to restore must be configured in the Bob.config file.
If a database already exists it will be replaced. If not it will be created at the default location or in the DatabasePath.





## Parameters

    
    -ProjectPath <String>
_The path to the Website project._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    
    
    -DatabasePath <String>
_The path where databases which does not exists yet should be created._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    
    
    -IncludeWebDatabase <SwitchParameter>
_By default `Import-ScDatabases` will skip the web databse.
If this parameter is speecified, also the web database will be imported._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | False | false | false |


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
    Import-ScDatabases






























### -------------------------- EXAMPLE 2 --------------------------
    Import-ScDatabases -DatabasePath D:\databases































