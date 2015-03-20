<#
.SYNOPSIS
Gets all databases configured for the specified project.

.DESCRIPTION
Gets all databases configured in the ConnectionStrings.config of the
specified project.

.PARAMETER ProjectPath
The path to the project to get the databases from.

.EXAMPLE
Get-ScDatabases

#>
function Get-ScDatabases
{
    [CmdletBinding()]
    Param(
        [string] $ProjectPath
    )
    Process
    {
        $config = Get-ScProjectConfig $ProjectPath

        $ConnectionStringsFile = Join-Path $config.WebsitePath $config.ConnectionStringsFolder

        if(-not $ConnectionStringsFile) {
            throw "No ConnectionStringsFile found. Please provide one."
        }

        if(-not (Test-Path $ConnectionStringsFile)) {
            Write-Error "Could not find ConnectionStrings file at '$ConnectionStringsFile'"
            exit
        }

        $connectionStrings = [xml](Get-Content $ConnectionStringsFile)

        $databases = @();

        if(-not $connectionStrings.connectionStrings.add) {
            Write-Warning "No ConnectionStrings found in '$ConnectionStringsFile'"
        }

        foreach($item in $connectionStrings.connectionStrings.add) {
            $connectionString = $item.connectionString;
            if(-not $item.connectionString) {
                Write-Warning "ConnectionString '$($item.name)' in '$ConnectionStringsFile' is empty."
            }

            $parts = $connectionString.split(';');
            foreach($part in $parts)
            {
                $keyValue = $part.split('=');
                $key = $keyValue[0].trim();
                if(("Database", "Initial Catalog") -contains $key) {
                    $databases += $keyValue[1]
                }
            }
        }

        $databases
    }
}
