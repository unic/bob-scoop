

# Install-SitecorePackage

Installs the correct Sitecore distribution to a specific location.
## Syntax

    Install-SitecorePackage [-OutputLocation] <String> [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Install-SitecorePackage installs the  correct Sitecore distribution to a specific location.
The Sitecore version is calculated by looking for Sitecore.Mvc.Config
or Sitecore.WebForms.Config installed to the Website proje





## Parameters

    
    -OutputLocation <String>
_The location where to extract the Sitecore distribution_

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -ProjectPath <String>
_The project path containing the Sitecore configuration._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Install-SitecorePackage -OutputLocation D:\Web\Magic































