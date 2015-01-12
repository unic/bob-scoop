<#
.SYNOPSIS
Creates the IIS Site and IIS Application Pool for the current Sitecore Website project.
.DESCRIPTION
Creates the IIS Site and IIS Application Pool for the current Sitecore Website project and adds a Host-Name entry in the Hosts file.

.EXAMPLE
Enable-ScSite
#>
Function Enable-ScSite
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param(
	  # Not in use anymore
      #  [String]$ProjectRootPath = ""
    )
    Begin{}

    Process
    {
        if(-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Error "Visual Studio is not running as Administrator. Please restart Visual Studio as Administrator."
        }

        $script:iisStoped = $false
        Function Stop-IIS {
            if(-not $iisStoped) {
                iisreset /stop
                $script:iisStoped = $true
            }
        }

        $localSetupConfig = Get-ScProjectConfig
        $siteName = $localSetupConfig.WebsiteCodeName

        $serverManager = New-Object Microsoft.Web.Administration.ServerManager;
        if(-not $serverManager.ApplicationPools[$siteName]) {
            Stop-IIS

            $appPool = $serverManager.ApplicationPools.Add($siteName);
            $appPool.ManagedRuntimeVersion = $localSetupConfig.AppPoolRuntime
            $serverManager.CommitChanges();
            "Added ApplicationPool '$siteName' with Runtime '$($localSetupConfig.AppPoolRuntime)'"

            # Wait for the changes to apply
            Start-sleep -milliseconds 1000

        }

        if (-not $serverManager.Sites[$siteName] ) {
            Stop-IIS
            $webPath = $localSetupConfig.WebRoot
            if(-not $webPath ) {
                Write-Error "Could not find WebRoot. Please configure it in the Bob.config"
            }
            $webSite = $serverManager.Sites.Add($siteName, $localSetupConfig.Protocol, ":80:" + $localSetupConfig.LocalHostName, $webPath);
            $webSite.Applications[0].ApplicationPoolName = $siteName;
            Start-sleep -milliseconds 1000
            $serverManager.CommitChanges();
            "Added Site '$siteName' with pointing to '$webPath'. URL: $($localSetupConfig.Protocol)://$($localSetupConfig.LocalHostName)"

            # Wait for the changes to apply
            Start-sleep -milliseconds 1000
        }

        $hostFilePath = Join-Path -Path $($env:windir) -ChildPath "system32\drivers\etc\hosts"
        if (-not (Test-Path -Path $hostFilePath)){
            Throw "Hosts file not found"
        }

        $ip = "127.0.0.1"

        $hostFile = Get-Content -Path $hostFilePath
        $hostEntry =  "$ip       $($localSetupConfig.LocalHostName) #$($localSetupConfig.HostsFileComment)"

        $hostFileEntryExist = $false;

        foreach($line in ($hostFile -split '[\r\n]') ){
            $line = $line.Trim();
            if($line.StartsWith("$ip")) {
                $line = $line.Substring($ip.Length).Trim();
                if($line.Contains("#")) {
                    $line = $line.Substring(0, $line.IndexOf("#")).Trim();
                }

                if($line -eq $localSetupConfig.LocalHostName) {
                    $hostFileEntryExist = $true;
                    break;
                }
            }
        }

        if(-not $hostFileEntryExist) {
            $hostFile += $hostEntry
            Set-Content -Value $hostFile -Path $hostFilePath -Force -Encoding ASCII

            Write-Output "Hosts file updated"
        }

        if($script:iisStoped) {
            iisreset /start
        }
    }
}
