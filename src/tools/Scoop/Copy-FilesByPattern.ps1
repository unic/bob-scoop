function Copy-FilesByPattern
{
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory=$true)]
      [string] $Source,
      [Parameter(Mandatory=$true)]
      [string] $Target,
      [Parameter(Mandatory=$true)]
      [string] $FilePatterns
  )
  Process
  {
    $Source = $Source.TrimEnd("\") + "\"

    $files = @()
    $fileFilters = $FilePatterns.Split(';') | % {$_.Trim()} | ? {$_ -ne ""}
    foreach($file in (ls $Source -Recurse )) {
      $relativePath = $file.FullName.ToLower().Replace($Source.ToLower(), "")
      foreach($filter in $fileFilters) {
        if($relativePath -like $filter) {
          $files += $relativePath
          break;
        }
      }
    }
    Write-Verbose "Found files by patteren: $([string]::Join(', ', $files))"

    $files | % {
      $targetFile = (Join-Path $Target $_)
      $parent = Split-Path $targetFile
      if(-not (Test-Path $parent)) {
        mkdir $parent | Out-Null
      }
      cp (Join-Path $Source $_) $targetFile -Force
    }
  }
}
