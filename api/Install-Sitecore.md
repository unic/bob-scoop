

# Install-Sitecore

Installs Sitecore with the correct version to the WebRoot
## Syntax

    Install-Sitecore [-Backup] [-Force] [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Installs Sitecore distribution with the correct version to the WebRoot
of the current project.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website project.
Optionally a backup of the WebRoot will be performed before everything will be overwritten.
In each case all unmanaged files will be backed-up and restored.
Additionally the connectionStrings.config file will be transformed by taking the ConnectionStrings.config
from the project as base, and the name of the SQL instance  from Bob.config.





## Parameters

    
    -Backup <SwitchParameter>
_If $true a backup of the entire WebRoot will be done before everything gets overwritten by Scoop. Default is $false_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | False | false | false |


----

    
    
    -Force <SwitchParameter>
_If $false nothing will be done if the WebRoot is not empty._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | True | false | false |


----

    
    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-Sitecore






























### -------------------------- EXAMPLE 2 --------------------------
    Install-Sitecore -Backup:$true






























### -------------------------- EXAMPLE 3 --------------------------
    Install-Sitecore -Force:$false































