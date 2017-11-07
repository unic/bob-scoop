<#
.SYNOPSIS
Generates a new SSL certificate with a specific CA

.DESCRIPTION
Generates a new SSL certificate with makeecert and signs it with a specific
certificate authority.
The certificate will get a validity of 20 years and be placed in the
machine-wide Personal keystore, so that it can be used by IIS.

.PARAMETER Name
The common name of the certificate.

.PARAMETER CA
The name of the certificate authority.

.EXAMPLE
New-Cert -Name local.cust.ch -CA Scoop

#>
function New-Cert
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        $CA

    )
    Process
    {
        $expires = (Get-Date).AddYears(100)

        return (New-SelfSignedCertificate -DnsName $Name -CertStoreLocation "cert:\LocalMachine\My" -Signer $CA -NotAfter $expires)


    }
}
