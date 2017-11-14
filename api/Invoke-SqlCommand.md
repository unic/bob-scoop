

# Invoke-SqlCommand

Invokes a script block with SQL specific error handling.
## Syntax

    Invoke-SqlCommand [-Command] <ScriptBlock> [<CommonParameters>]


## Description

Invokes a script block with SQL specific error handling.
When an error happens durring a SQL operation the real error message is hidden
in a deep InnerException. Invoke-SqlCommand ensures that a clean error message
is thrown when an SQL error happen.





## Parameters

    
    -Command <ScriptBlock>
_The command to execute._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    































