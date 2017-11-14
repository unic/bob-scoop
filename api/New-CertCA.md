

# New-CertCA

Generates a new certificate which can be used as certificate authority.
## Syntax

    New-CertCA [-Name] <String> [<CommonParameters>]


## Description

Generates a new certificate which can be used as certificate authority. The certificate will be placed in the machine-wide "Trusted Certificate
Authorities" and will have a validity of 20 years.





## Parameters

    
    -Name <String>
_The name of the certificate authority._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    New-CertCA -Name Scoop































