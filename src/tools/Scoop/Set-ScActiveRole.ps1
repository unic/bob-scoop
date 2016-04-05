<#
.SYNOPSIS
Sets the active role (delivery or author).

.DESCRIPTION
Sets the ActiveRole property in the Bob.config.user
and build the solution.

.PARAMETER Role
The role to set (delivery or author).

.EXAMPLE
Set-ScActiveRole delivery

#>
function Set-ScActiveRole
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $Role
  )
  Process
  {
     Set-ScUserConfigValue -Key "ActiveRole" -Value $Role
     
     if($dte) {
        $dte.Solution.SolutionBuild.Build()
     }
  }
}
