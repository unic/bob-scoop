<#
.SYNOPSIS
Generates a new SSL certificate with a specific CA

.DESCRIPTION
Generates a new SSL certificate with makeecert and signs it with a specific
certificate authority.
The certifiacte will get a validity of 20 years and be placed in the
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
        [string] $CA

    )
    Process
    {
        $validFrom = (Get-Date).AddDays(-1).ToString("MM/dd/yyyy", [CultureInfo]::InvariantCulture)

        $params = @("-pe"
        , "-ss"
        , "My"
        , "-sr"
        , "LocalMachine"
        ,"-n"
        ,"CN=$Name, $ScoopCertificatePath"
        ,"-sky"
        ,"exchange"
        ,"-in"
        ,"$CA"
        ,"-is"
        ,"Root"
        , "LocalMachine"
        ,"-eku"
        ,"1.3.6.1.5.5.7.3.1"
        ,"-cy"
        ,"end"
        ,"-a"
        ,"sha1"
        ,"-m"
        ,"240"
        ,"-b"
        ,"$validFrom")

        & (ResolveBinPath "makecert.exe") $params


    }
}
