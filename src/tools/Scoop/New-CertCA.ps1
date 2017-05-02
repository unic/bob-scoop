<#
.SYNOPSIS
Generates a new certificate which can be used as certificate authority.

.DESCRIPTION
Generates a new certificate which can be used as certificate authority. The certificate will be placed in the machine-wide "Trusted Certificate
Authorities" and will have a validity of 20 years.

.PARAMETER Name
The name of the certificate authority.

.EXAMPLE
New-CertCA -Name Scoop

#>
function New-CertCA
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Name
    )
    Process
    {
        $expires = (Get-Date).AddYears(100)

        $cert = New-SelfSignedCertificate -CertStoreLocation cert:\LocalMachine\My -dnsname $Name  -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1", "2.5.29.19={text}CA=true") -KeyUsage CertSign -NotAfter $expires 

        $DestStoreScope = 'LocalMachine'
        $DestStoreName = 'root'

        $DestStore = New-Object  -TypeName System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList $DestStoreName, $DestStoreScope
        $DestStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $DestStore.Add($cert)

        $DestStore.Close()

        return $cert
    }
}
