<#
.SYNOPSIS
Backup the web root nased on a specific file pattern.
.DESCRIPTION
Backup the web root nased on a specific file pattern.

.PARAMETER WebRoot
The folder to backup.

.PARAMTER BackupFolder
The folder where the files should be backuped to.

.PARAMTER FilePatterns
A semicolon separated list of file patterns.
If this paramter is specified only files which matches the pattern will be copied.

.EXAMPLE
Backup-ScWebRoot -WebRoot D:\web\post-internet\Web -BackupFolder d:\temp\bak -FilePatterns "App_Config\*;Web.config"
#>
function Backup-ScWebRoot
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $WebRoot,
      [Parameter(Mandatory=$true)]
      [string] $BackupFolder,
      [string] $FilePatterns
  )
  Process
  {
    $webRoot = $webRoot.TrimEnd("\") + "\"
    if($FilePatterns) {
      $files = @()
      $fileFilters = $FilePatterns.Split(';') | % {$_.Trim()} | ? {$_ -ne ""}
      foreach($file in (ls $WebRoot -Recurse )) {
        $relativePath = $file.FullName.ToLower().Replace($WebRoot.ToLower(), "")
        foreach($filter in $fileFilters) {
          if($relativePath -like $filter) {
            $files += $relativePath
            break;
          }
        }
      }
      Write-Verbose "Found required files: $([string]::Join(', ', $files))"

      $files | % {
        $target = (Join-Path $BackupFolder $_)
        $parent = Split-Path $target
        if(-not (Test-Path $parent)) {
          mkdir $parent | Out-Null
        }
        cp (Join-Path $webRoot $_) $target
      }
    }
    else {
      cp "$webRoot*" $BackupFolder -Recurse
    }
  }
}
