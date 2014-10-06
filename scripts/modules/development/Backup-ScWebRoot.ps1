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
