<#
.SYNOPSIS
Invokes a script block with SQL specific error handling.

.DESCRIPTION
Invokes a script block with SQL specific error handling.
When an error happens durring a SQL operation the real error message is hidden
in a deep InnerException. Invoke-SqlCommand ensures that a clean error message
is thrown when an SQL error happen.

.PARAMETER Command
The command to execute.

.EXAMPLE

#>
function Invoke-SqlCommand
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ScriptBlock] $Command
    )
    Process
    {
        try {
            & $Command
        }
        catch {
            $sqlEx = (GetSqlExcpetion $_.Exception )
            if($sqlEx) {
                Write-Error $sqlEx
            }
            else {
                Write-Error $_
            }
        }
    }
}
