# Changelog

## 2.1.2
* Fixed a problem with certificate installation when https was the first binding

## 2.1
* Implemented updating connection strings during Install-Sitecore execution

## 2.0
* Added support for Bob 2.0

## 1.6.2
* Added a new function 'Set-ScActiveEnvironment' for environment impersonation.

## 1.6.1
* Removed Keith and Pester from Nuget package

## 1.6
* 'Enable-ScSite' now checks if the configured path is existing or can be created.
* Updated Bob config to 1.4 to fix 'Import-ScDatabases'.
* Updated Pester and Skip.

## 1.5
* `Import-ScDatabases` now resets the password of the "admin" user to "b"
* `bump` will no chat a lot more

## 1.4.1
* Enhanced output of `Install-ScSerilaizationPackage` in order to get log file in Lofty working

## 1.4
* `Import-ScDatabases` now ignores the web database by default
* Fix  `Install-ScDatabases` Analytics setup in Sitecore 8
* Fix `bump` when Dizzy is not installed

## 1.3.1
* Update Bob config to 1.2 in order to fix external console launch.

## 1.3
* Added `Update-Sitecore` and `Update-ScDatabases`
* Moved `Install-ScSerilaizationPackage` from Lofty to Scoop

## 1.2.1
* Fixed Analytics database for Sitecore 7.2 and lower in `Install-ScDatabases`

## 1.2
* When NuGet creadentials are not saved in the NuGet.config, Scoop will ask for
    them and add them to NuGet.config
* Added support for Sitecore 8 Analytics and Session database in `Install-ScDatabases`


## 1.1
* Added `Install-ScDatabases`
* Added `Sync-ScDatabases`
* `Enable-ScSite` will now configure database security
* Added `ImportDatabaseTempLocation` config key
* Added `Start/Stop-ScAppPool`


## 1.0
* Initial version
