

# Install-NugetPackageToCache

Installs a NuGet package to the Bob-Cache.
## Syntax

    Install-NugetPackageToCache [[-PackageId] <Object>] [[-Version] <Object>] [[-ProjectPath] <Object>] [<CommonParameters>]


## Description

Installs the specified NuGet package to "${env:AppData}\Bob\$PackageId 
if it's not yet installed there.





## Parameters

    
    -PackageId <Object>
_The NuGet package id._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    
    
    -Version <Object>
_The version of the package to install._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    
    
    -ProjectPath <Object>
_The path to the project._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-NugetPackageToCache  -PackageId Unic.Test -Version 3.2































