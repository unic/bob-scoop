

# New-Cert

Generates a new SSL certificate with a specific CA
## Syntax

    New-Cert [-Name] <String> [-CA] <Object> [<CommonParameters>]


## Description

Generates a new SSL certificate with makeecert and signs it with a specific
certificate authority.
The certificate will get a validity of 20 years and be placed in the
machine-wide Personal keystore, so that it can be used by IIS.





## Parameters

    
    -Name <String>
_The common name of the certificate._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -CA <Object>
_The name of the certificate authority._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    New-Cert -Name local.cust.ch -CA Scoop































