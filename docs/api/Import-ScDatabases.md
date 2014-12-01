

# Import-ScDatabases

Restores all Databases of a project from a file share.

## Syntax

    Import-ScDatabases [[-ConnectionStringsFile] <String>] [[-VSProjectRootPath] <String>] [[-ProjectRootPath] <String>] [[-DatabasePath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Restores all Databases which are referenced in the ConnectionStrings file of the Project.
The location where the backups to restore are taken must be configured in the Bob.config file.
If a database already exists it will be replaced. If not it will be created at the default location or in the DatabasePath.





## Parameters

    
    -ConnectionStringsFile <String>

The path which of the configuration file which contains the ConnectionStrings





Required?  false

Position? 1

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -VSProjectRootPath <String>

The folder where the Visual Studio project is located.
This is only used if no ConnectionStringsFile is provided to search the ConnectionStringsFile inside of this folder.
If this Parameter is also not provided the ConnectionStringsFile is searched in the current Visual Studio project.





Required?  false

Position? 2

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -ProjectRootPath <String>

Not used in this anymore!





Required?  false

Position? 3

Default value? 

Accept pipeline input? false

Accept wildchard characters? false
    
    
    -DatabasePath <String>

The path where databases which does not exists yet should be created.





Required?  false

Position? 4

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
    Import-ScDatabases






























### -------------------------- EXAMPLE 2 --------------------------
    Import-ScDatabases -DatabasePath D:\databases































