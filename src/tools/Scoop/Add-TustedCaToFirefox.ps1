<#
.SYNOPSIS
Adds a trusted certificate authority to Firefox.

.DESCRIPTION
Adds a trusted certificate authority to the Firefox key store.
*Note*: Firefox mustn't run when executing this command.

.PARAMETER Name
The common name of the certificate.

.EXAMPLE
Add-TrustedCaToFirefox -Name Scoop

#>
function Add-TrustedCaToFirefox
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Name
    )
    Process
    {
        $cert = ls Cert:\LocalMachine\Root | ? {$_.Subject -like "CN=$Name"}
        if(-not $cert) {
            Write-Error "Cert $Name not found."
        }

        $profiles = ls C:\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*
        if($profiles) {
            $isTrusted = (($profiles | %  {
                $trusted = & (ResolveBinPath "certutil.exe") -L -d $_.FullName
                ($trusted | % {$_.Contains($Name + " ")}) -gt 0
            } | ? {$_ -eq $true}).Count -eq $profiles.Count)

            if(-not $isTrusted) {

                if(Get-Process firefox -ErrorAction SilentlyContinue) {
                    Write-Warning "Firefox is running. Stop Firefox and execute 'Add-TrustedCaToFirefox $Name' to trust the certificate in Firefox."
                    return
                }

                $cerPath = "${env:TEMP}\$Name.cer"

                $content = "-----BEGIN CERTIFICATE-----`n" +
                            [System.Convert]::ToBase64String($cert.Export("Cert"), "InsertLineBreaks") + "`n" +
                            "-----END CERTIFICATE-----"
                $content | Out-File "${env:TEMP}\$Name.cer" -Encoding UTF8

                $profiles | % {
                     & (ResolveBinPath "certutil.exe") -A -d $_.FullName -n "$Name" -t "CT,," -a -i $cerPath
                     Write-Verbose "Trusted certificate $Name in $($_.FullName)"
                }

                rm $cerPath
            }
        }
    }
}
