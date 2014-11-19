function Initialize-Environment
{
    [CmdletBinding()]
    Param(
    )
    Process
    {
        Enable-ScSite
        Install-Sitecore
        Set-ScSerializationReference
        Import-ScDatabases
    }
}

Set-Alias bump Initialize-Environment
