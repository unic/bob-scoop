$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

Import-Module "$here\development.psm1"

Describe "Merge-ConnectionStrings" {
  Context "connectionStrings.config and Bob.config are provided" {
    Mock Get-ScProjectConfig {return @{
      "WebsitePath" = "TestDrive:\";
      "ConnectionStringsFolder" = "input.config"
      "DatabaseServer" = "testserver";
    }} -ModuleName development

    @"
<?xml version="1.0" encoding="utf-8"?>
<connectionStrings>
  <add name="core" connectionString="Data Source=localhost;Database=cust_sc_internet_core;Integrated Security=True" />
  <add name="master" connectionString="Database=cust_sc_internet_master;Server=localhost;Integrated Security=True" />
  <add name="web" connectionString="Database=cust_sc_internet_master;Integrated Security=True;Address=localhost" />
</connectionStrings>
"@ | Out-File "TestDrive:\input.config" -Encoding UTF8

    Merge-ConnectionStrings -OutputLocation "TestDrive:\output.config"

    $config = [xml](Get-Content "TestDrive:\output.config")

    It "Should merge connection strings when DataSource is at the beginning" {
      $config.connectionStrings.add[0].connectionString  | Should Be "Data Source=testserver;Database=cust_sc_internet_core;Integrated Security=True"
    }

    It "Should merge connection strings when DataSource is in the middle" {
      $config.connectionStrings.add[1].connectionString  | Should Be "Database=cust_sc_internet_master;Server=testserver;Integrated Security=True"
    }

    It "Should merge connection strings when DataSource is at the end" {
      $config.connectionStrings.add[2].connectionString  | Should Be "Database=cust_sc_internet_master;Integrated Security=True;Address=testserver"
    }
  }
}
