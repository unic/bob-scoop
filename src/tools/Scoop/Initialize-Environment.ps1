function Initialize-Environment
{
    [CmdletBinding()]
    Param(
    )
    Process
    {
        Enable-ScSite -Verbose
        Install-Sitecore -Verbose
        Set-ScSerializationReference -Verbose
        Import-ScDatabases -Verbose
    }
}

Set-Alias bump Initialize-Environment
