

# Install-ScSerializationPackage

Installs a Sitecore Package with Sitecore Ship
## Syntax

    Install-ScSerializationPackage [-Path] <String> [-Url] <String> [[-DisableIndexing] <Boolean>] [[-PackageId] <String>] [[-Description] <String>] [-Publish] [[-PublishMode] <String>] [[-PublishSource] <String>] [[-PublishTargets] <String>] [[-PublishLanugages] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Description

This command can be used to install a Sitecore package with the help of Sitecore Ship by specifying the location of an update package file to upload to the server. Optionaly a Publish job will be triggered after the installation.





## Parameters

    
    -Path <String>
_The Path to the Sitecore update pacakge_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -Url <String>
_The Base-Url of the Sitecore Environment to install the package._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    
    
    -DisableIndexing <Boolean>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false | False | false | false |


----

    
    
    -PackageId <String>
_If recordInstallationHistory  is enabled you have to provide this parameter._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | false |  | false | false |


----

    
    
    -Description <String>
_If recordInstallationHistory  is enabled you have to provide this parameter._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 5 | false |  | false | false |


----

    
    
    -Publish <SwitchParameter>
_If this switch is added a publish jobb will be triggered after the package install_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| named | false | False | false | false |


----

    
    
    -PublishMode <String>
_Must be one of the following values:
 - full
 - smart
 - incremental_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 6 | false |  | false | false |


----

    
    
    -PublishSource <String>
_Detault is master_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 7 | false |  | false | false |


----

    
    
    -PublishTargets <String>
_Default is web_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 8 | false |  | false | false |


----

    
    
    -PublishLanugages <String>
_Default is en_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 9 | false |  | false | false |


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
    Install-ScSerializationPackage -Path D:\Deployment\64-items.update -Url http://local.post.ch































