

# Enable-ScSite

Creates the IIS Site and IIS Application Pool for the current Sitecore Website project.
## Syntax

    Enable-ScSite [-Force] [[-ProjectPath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

Creates the IIS Site and IIS Application Pool for the current Sitecore Website
project and adds all host-names to the hosts file. Additionally it creates an
SSL certificate for every HTTPS binding specified in the Bob.config.
Enable-ScSite will also add the "NT Authority\Service" group as administrator to
the SQL server.





## Parameters

    
    -Force <SwitchParameter>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | False | false | false |


----

    
    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


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
    Enable-ScSite































