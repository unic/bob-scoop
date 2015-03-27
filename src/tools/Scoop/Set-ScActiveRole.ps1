<#
.SYNOPSIS
Sets the active role (delivery or author)
.DESCRIPTION
Sets the ActiveRole property in the Bob.config.user
and build the solution.

.PARAMETER
The role to set (delivery or author)

.EXAMPLE
Set-ScActiveRole delivery

#>
function Set-ScActiveRole
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("delivery","author")]
      [string] $Role
  )
  Process
  {
     $config = Get-ScProjectConfig
     Set-ScUserConfigValue -Key "ActiveRole" -Value $Role
     if($dte) {
        $dte.Solution.SolutionBuild.Build()
     }
  }
}
