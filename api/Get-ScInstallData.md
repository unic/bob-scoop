

# Get-ScInstallData

Installs all required packages and returns the paths required for a Sitecore 9 installation.
## Syntax

    Get-ScInstallData [[-ProjectPath] <String>] [<CommonParameters>]


## Description

Installs the following nuget packages:
- Sitecore.Fundamentals
- Sitecore.Sif
- Sitecore.Xp0.Wdp
- Sitecore.Xp0.XConnect.Wdp
- Sitecore.Sif.Config

The return type is a hashtable containing the following properties which can directly be fed into the Scratch Install-*Setup Cmdlets:
- SifPath
- FundamentalsPath
- SifConfigPathSitecoreXp0
- SifConfigPathXConnectXp0
- SifConfigPathCreateCerts
- SitecorePackagePath
- XConnectPackagePath
- LicenseFilePath
- CertCreationLocation





## Parameters

    
    -ProjectPath <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Get-ScInstallData































