

# Add-SqlAdmin

Adds a Windows User as SQL  administrator.
## Syntax

    Add-SqlAdmin [-Server] <String> [-User] <String> [<CommonParameters>]


## Description

Adds a Windows User as SQL  administrator.





## Parameters

    
    -Server <String>
_The name of the SQL server to connect to._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -User <String>
_The name of the user to register as admin._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Add-SqlAdmin -Server localhost -User "NT Authority\Service"































