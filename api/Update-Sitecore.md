

# Update-Sitecore

Updates all NuGet packages of Sitecore to a new version.
## Syntax

    Update-Sitecore [-Version] <String> [<CommonParameters>]


## Description

Sets the allowedVersions attribute of the Sitecore package in packages.config
of all projects to the new version. Then it updates every package referencing the
Sitecore package to the new version.





## Parameters

    
    -Version <String>
_The version to update to._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Update-Sitecore -Version 7.2.12345.56































