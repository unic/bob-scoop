<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

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
