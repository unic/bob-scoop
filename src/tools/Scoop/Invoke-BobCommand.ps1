function Invoke-BobCommand
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ScriptBlock] $Code
    )
    Process
    {
        if((-not $NoRestart) -or $host.Name -eq "Package Manager Host") {
            $caller = (Get-PSCallStack)[1]
            $command = Get-Command $caller.Command
            $module = $command.Module.Path
            $parameters = $caller.InvocationInfo.BoundParameters
            $newCommand = $caller.Command
            foreach($key in $parameters.Keys) {
                $value = $parameters[$key]

                if($command.Parameters[$key].ParameterType -eq [System.Management.Automation.SwitchParameter]) {
                    $newCommand += " -${Key}:`$$value"
                }
                else {
                    $escapedValue = $value -replace "'", "``'"
                    $newCommand += " -${Key} '$escapedValue'"
                }
            }

            if(-not ($caller.InvocationInfo.BoundParameters["ProjectPath"])) {
                    $projectPath = Get-ScProjectPath
                $newCommand += " -ProjectPath $projectPath"
            }

            Write-Host   $newCommand
            write-host $module

            C:\Windows\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NoLogo {
                param($module, $command)
                $NoRestart = $true
                Import-Module $module
                iex $command
            } -args $module, $newCommand
        }
        else {
            & $Code
        }
    }
}
