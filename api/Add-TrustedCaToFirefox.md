

# Add-TrustedCaToFirefox

Adds a trusted certificate authority to Firefox.
## Syntax

    Add-TrustedCaToFirefox [-Name] <String> [<CommonParameters>]


## Description

Adds a trusted certificate authority to the Firefox key store.
*Note*: Firefox mustn't run when executing this command.





## Parameters

    
    -Name <String>
_The common name of the certificate._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Add-TrustedCaToFirefox -Name Scoop































