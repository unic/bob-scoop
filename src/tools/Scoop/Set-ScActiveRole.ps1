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
