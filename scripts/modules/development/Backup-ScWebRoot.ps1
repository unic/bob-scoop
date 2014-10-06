function Backup-ScWebRoot
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $WebRoot,
      [Parameter(Mandatory=$true)]
      [string] $BackupFolder,
      [Parameter(Mandatory=$true)]
      [string] $FilePatterns,
      [Switch] $Full = $false
  )
  Process
  {
    $webRoot = $webRoot.TrimEnd("\") + "\"

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
    $requiredBackupPath = Join-Path $BackupFolder "Required"
    if(Test-Path $requiredBackupPath) {
      rm $requiredBackupPath -Recurse
    }
    mkdir $requiredBackupPath | Out-Null
    $files | % {
      $target = (Join-Path $requiredBackupPath $_)
      $parent = Split-Path $target
      if(-not (Test-Path $parent)) {
        mkdir $parent | Out-Null
      }
      cp (Join-Path $webRoot $_) $target
    }
  }
}
