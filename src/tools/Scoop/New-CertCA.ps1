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
        $validFrom = (Get-Date).AddDays(-1).ToString("MM/dd/yyyy", [CultureInfo]::InvariantCulture)

        $params = @("-r"
        , "-ss"
        , "Root"
        , "-sr"
        , "LocalMachine"
        , "-n"
        , "CN=$Name, $ScoopCertificatePath"
        , "-sky"
        , "signature"
        , "-eku"
        , "1.3.6.1.5.5.7.3.1"
        , "-h"
        , "1"
        , "-cy"
        , "authority"
        , "-a"
        , "sha1"
        , "-m"
        , "240"
        , "-b"
        , "$validFrom")

        & (ResolveBinPath "makecert.exe") $params
    }
}
