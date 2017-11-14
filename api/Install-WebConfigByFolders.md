

# Install-WebConfigByFolders

Transforms all Web.*.config with the Sitecore web.config and puts it to the web-root.
## Syntax

    Install-WebConfigByFolders [[-Folders] <String[]>] [[-ConfigPath] <String>] [[-Environment] <String>] [[-Role] <String[]>] [[-AdditionalXdtFiles] <String[]>] [<CommonParameters>]


## Description

Transforms all Web.*.config of all projects in the repo
with the Sitecore web.config and puts it to the web-root.





## Parameters

    
    -Folders <String[]>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    
    
    -ConfigPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    
    
    -Environment <String>
_The environment for which the web-configs should be transformed._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false | local | false | false |


----

    
    
    -Role <String[]>
_The role for which the web-configs should be transformed._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | false | @("author") | false | false |


----

    
    
    -AdditionalXdtFiles <String[]>
_A list of additional XDT files which should be applied to the Web.config at the end of the process._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 5 | false | @() | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-WebConfigByFolders -Folders @(".\Website") -ConfigPath "." -AdditionalXdtFiles @("C:\template\Web.config.xdt")































