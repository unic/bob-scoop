<#
.SYNOPSIS

.DESCRIPTION


.PARAMETER

.EXAMPLE

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
