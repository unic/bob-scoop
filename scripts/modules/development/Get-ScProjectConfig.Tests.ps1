$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Get-ScProjectConfig" {
  Context "Bob.user.config" {
    function global:Get-Project { @{"FullName" = "TestDrive:\Dummy.csproj"}}

    $bobConfig = @"
<?xml version="1.0" encoding="utf-8"?>
    <Configuration xmlns="http://www.unic.com/Bob">
      <WebsiteCodeName>Website code parent</WebsiteCodeName>
      <LocalHostName>local host name code parent</LocalHostName>
    </Configuration>
"@
    $bobUserConfig = @"
<?xml version="1.0" encoding="utf-8"?>
    <Configuration xmlns="http://www.unic.com/Bob">
      <LocalHostName>local host name code child</LocalHostName>
    </Configuration>
"@
    mkdir "TestDrive:\App_Config"
    $bobConfig | Out-File "TestDrive:\App_Config\Bob.config" -Encoding UTF8
    $bobUserConfig | Out-File "TestDrive:\App_Config\Bob.config.user" -Encoding UTF8


    $config = Get-ScProjectConfig

    It "Should have keep parent value for WebsiteCodeName" {
      $config.WebsiteCodeName | Should Be "Website code parent"
    }

    It "Should have take child value for LocalHostName" {
      $config.LocalHostName | Should Be "local host name code child"
    }
  }
}
