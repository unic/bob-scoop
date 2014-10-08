function Restore-ScWebRootUnmanaged
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $WebRoot,
      [Parameter(Mandatory=$true)]
      [string] $BackupFolder,
      [Parameter(Mandatory=$true)]
      [string] $FilePatterns
  )
  Process
  {
    $BackupFolder = $BackupFolder.TrimEnd("\") + "\"

    $files = @()
    $fileFilters = $FilePatterns.Split(';') | % {$_.Trim()} | ? {$_ -ne ""}
    foreach($file in (ls $BackupFolder -Recurse )) {
      $relativePath = $file.FullName -replace  ([Regex]::Escape($BackupFolder)), ""
      foreach($filter in $fileFilters) {
        if($relativePath -like $filter) {
          $files += $relativePath
          break;
        }
      }
    }
    Write-Verbose "Found required files: $([string]::Join(', ', $files))"

    $files | % {
      $target = (Join-Path $WebRoot $_)
      $parent = Split-Path $target
      if(-not (Test-Path $parent)) {
        mkdir $parent | Out-Null
      }
      cp (Join-Path $BackupFolder $_) $target
    }
  }
}
