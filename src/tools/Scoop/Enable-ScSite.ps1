<#
.SYNOPSIS
Creates the IIS Site and IIS Application Pool for the current Sitecore Website project.
.DESCRIPTION
Creates the IIS Site and IIS Application Pool for the current Sitecore Website
project and adds all host-names to the hosts file. Additionally it creates an
SSL certificate for every HTTPS binding specified in the Bob.config.

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
        [switch] $Force = $false,
        [string] $ProjectPath
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

        $localSetupConfig = Get-ScProjectConfig -ProjectPath $ProjectPath
        $siteName = $localSetupConfig.WebsiteCodeName


        Import-Module WebAdministration -Verbose:$false
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

        $rawBindings = $localSetupConfig.IISBindings
        if(-not $rawBindings) {
            Write-Error "No IIS bindings where found. Provide at least one in Bob.config or Bob.config.user with the key IISBindings"
        }

        $bindings = $rawBindings | % {
            $url = $_.InnerText
            if(-not ( [System.Uri]::IsWellFormedUriString($url, "Absolute"))) {
                Write-Error "Binding $($_.OuterXml) contains no valid url."
            }
            $uri = New-Object System.Uri $url

            @{
                "port" = $uri.Port;
                "protocol" = $uri.Scheme;
                "host" = $uri.Authority;
                "ip" = $_.ip;
            }
        }

        if (-not $serverManager.Sites[$siteName] ) {
            Stop-IIS
            $webPath = $localSetupConfig.WebRoot
            if(-not $webPath ) {
                Write-Error "Could not find WebRoot. Please configure it in the Bob.config"
            }
            $protocol = $bindings[0].protocol
            $port = $bindings[0].port
            $host = $bindings[0].host
            $ip = $bindings[0].ip

            $webSite = $serverManager.Sites.Add($siteName, $protocol, $ip + ":" + $port + ":" + $host, $webPath);
            $webSite.Applications[0].ApplicationPoolName = $siteName;
            Start-sleep -milliseconds 1000
            $serverManager.CommitChanges();
            "Added site '$siteName' with the WebRoot '$webPath'. URL: ${protocol}://${host}:${port}"

            # Wait for the changes to apply
            Start-sleep -milliseconds 1000
        }

        $site = $serverManager.Sites[$siteName]
        if(-not $Force) {
            $existingBindings = $site.Bindings | % {
                $parts = $_.bindingInformation.Split(":")
                 @{"ip"= $parts[0] ; "port" = $parts[1]; "host" = $parts[2]; "protocol" = $_.protocol}
            }
        }
        else {
            $site.Bindings.Clear()
        }

        $CAName = "Scoop"
        $IPs = @()

        foreach($binding in $bindings) {
            $port = $binding.port
            $protocol = $binding.protocol
            $hostname = $binding.host
            $ip = $binding.ip
            if(-not $ip) {
                # Force IP to be not null
                $ip = ""
                $IPs += @{"ip" = "127.0.0.1"; "host" = "$hostname"};
            }
            else {
                $IPs += @{"ip" = "$ip"; "host" = "$hostname"};
            }

            if(-not ($existingBindings |
                ? {$_.port -eq $port -and $_.host -eq $hostname -and $_.protocol -eq $protocol -and $_.ip -eq $ip})) {

                if($protocol -eq "https") {
                    $ca = ls Cert:\LocalMachine\Root | ? {$_.Subject -like "CN=$CAName, $ScoopCertificatePath"}
                    if(-not $ca) {
                        New-CertCA $CAName
                        Write-Host "Created certificate authority $CAName"
                    }
                    Add-TrustedCaToFirefox $CAName

                    $cert = ls Cert:\LocalMachine\My | ? {$_.Subject -like "CN=$hostname, $ScoopCertificatePath"}
                    if(-not $cert) {
                        New-Cert $hostname -CA $CAName
                        Write-Host "Created certificate for host $hostname"
                    }

                    $cert = ls Cert:\LocalMachine\My | ? {$_.Subject -like "CN=$hostname, $ScoopCertificatePath"}

                    $site.Bindings.Add("${ip}:${port}:${hostname}", $cert.GetCertHash(), "MY") | Out-Null
                }
                else {
                    $site.Bindings.Add("${ip}:${port}:${hostname}", $protocol) | Out-Null
                }
                Write-Verbose "Added binding $protocol, $hostname, $port on IP '$ip'"
            }
        }
        $serverManager.CommitChanges()

        $hostFilePath = Join-Path -Path $($env:windir) -ChildPath "system32\drivers\etc\hosts"
        if (-not (Test-Path -Path $hostFilePath)){
            Throw "Hosts file not found"
        }

        $ipHash = @{}

        foreach($ipHostName in $IPs) {
            $ip = $ipHostName.ip
            $hostName = $ipHostName.host
            if($ipHash[$hostName] -and $ipHash[$hostName] -ne $ip) {
                Write-Warning "Hostname $hostName has multiple IPs. The IP $ip will not be written to the hosts file."
                continue;
            }
            $ipHash[$hostName] = $ip

            $hostFile = Get-Content -Path $hostFilePath
            $hostFile = $hostFile -split '[\r\n]'

            $hostFileEntryExist = $false;

            [string[]]$newHostFile = @()

            $hostFileRegex = "^((?:\d\d?\d?\.){3}\d\d?\d?)\s*(.+?)(#.*)?$"

            foreach($line in $hostFile) {
                if($line -match $hostFileRegex) {
                    $lineIp = $matches[1]
                    $lineHost = $matches[2].Trim()
                    if($lineHost -eq $hostName) {
                        if($ip -eq $lineIp) {
                            $newHostFile += $line
                            $hostFileEntryExist = $true
                        }
                        else {
                            Write-Warning "$hostName has currently the IP $lineIp in the hosts file. This will be overwritten by the new IP $ip"
                            $newHostFile += "#" +  $line
                        }
                    }
                    else {
                        $newHostFile += $line
                    }
                }
                else {
                    $newHostFile += $line
                }
            }

            if(-not $hostFileEntryExist) {
                $newHostFile +=  "$ip       $($hostName) # Site: $($siteName) - $($localSetupConfig.HostsFileComment)"

                Set-Content -Value ([string]::Join("`r`n",$newHostFile )) -Path $hostFilePath -Force -Encoding ASCII
                sleep -m 2

                Write-Output "Hosts file updated"
            }
        }

        if($script:iisStoped) {
            iisreset /start
        }
    }
}
