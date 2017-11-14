

# Install-ScDatabases

Installs all databases of the project based on empty databases.
## Syntax

    Install-ScDatabases [[-ProjectPath] <String>] [[-DatabasePath] <String>] [-Force] [[-Databases] <String[]>] [<CommonParameters>]


## Description

Installs all databases of the project based on different criterias:
- The Sitecore Core, Master and Web will be created based on the original
databases from Sitecore.
- For all other databases the information from the "InitDatabasesPath"  is relevant.
If in the database path a file exists with the format "databaseName.sql",
this SQL file will be used to create the database.
If in the database path a file exists with the format "databaseName.ref",
the file content must be "web", "master" or "core", the coresponding original Sitecore
database will then be used to create this database.
The "InitDatabasesPath" can be configured in the Bob.config





## Parameters

    
    -ProjectPath <String>
_The path to the project for which the databases should be installed._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    
    
    -DatabasePath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    
    
    -Force <SwitchParameter>
_If force is specified, all databases which already exist will be deleted first.
If force is not specified, existing databases will be skipped._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | False | false | false |


----

    
    
    -Databases <String[]>
_An alternative list of databases to install. If it's ommited the databases from
 the connection string will be used._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-ScDatabases -DatabasePath C:\data































