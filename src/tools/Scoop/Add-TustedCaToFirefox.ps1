<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

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
        $cert = ls Cert:\LocalMachine\Root | ? {$_.Subject -like "CN=$Name, $ScoopCertificatePath"}
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
                    Write-Warning "Firefox is running. Stop Firefox and rerun the command to trust the certificate in Firefox."
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
