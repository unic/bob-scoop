# Scoop - API

##  Add-SqlAdmin
Adds a Windows User as SQL  administrator.    
    
    Add-SqlAdmin [-Server] <String> [-User] <String> [<CommonParameters>]


 [Read more](Add-SqlAdmin.md)
##  Add-TrustedCaToFirefox
Adds a trusted certificate authority to Firefox.    
    
    Add-TrustedCaToFirefox [-Name] <String> [<CommonParameters>]


 [Read more](Add-TrustedCaToFirefox.md)
##  Connect-SqlServer
Connects to the SQL server configured in the project.    
    
    Connect-SqlServer [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Connect-SqlServer.md)
##  Copy-UnmanagedFiles
Copies all unmanaged files of the current project to the WebRoot.    
    
    Copy-UnmanagedFiles [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Copy-UnmanagedFiles.md)
##  Enable-ScSite
Creates the IIS Site and IIS Application Pool for the current Sitecore Website project.    
    
    Enable-ScSite [-Force] [[-ProjectPath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](Enable-ScSite.md)
##  Get-ScContextInfo
Get the current Sitecore type and version.    
    
    Get-ScContextInfo [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Get-ScContextInfo.md)
##  Get-ScDatabases
Gets all databases configured for the specified project.    
    
    Get-ScDatabases [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Get-ScDatabases.md)
##  GetSqlExcpetion
    GetSqlExcpetion [[-ex] <Object>]


 [Read more](GetSqlExcpetion.md)
##  Import-ScDatabases
Restores all databases of a project from a file share.    
    
    Import-ScDatabases [[-ProjectPath] <String>] [[-DatabasePath] <String>] [-IncludeWebDatabase] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](Import-ScDatabases.md)
##  Initialize-Environment
Performs all actions required on the local system to get started with a new project.    
    
    Initialize-Environment [<CommonParameters>]


 [Read more](Initialize-Environment.md)
##  Install-NugetPackageToCache
Installs a NuGet package to the Bob-Cache.    
    
    Install-NugetPackageToCache [[-PackageId] <Object>] [[-Version] <Object>] [[-ProjectPath] <Object>] [<CommonParameters>]


 [Read more](Install-NugetPackageToCache.md)
##  Install-ScDatabases
Installs all databases of the project based on empty databases.    
    
    Install-ScDatabases [[-ProjectPath] <String>] [[-DatabasePath] <String>] [-Force] [[-Databases] <String[]>] [<CommonParameters>]


 [Read more](Install-ScDatabases.md)
##  Install-ScSerializationPackage
Installs a Sitecore Package with Sitecore Ship    
    
    Install-ScSerializationPackage [-Path] <String> [-Url] <String> [[-DisableIndexing] <Boolean>] [[-PackageId] <String>] [[-Description] <String>] [-Publish] [[-PublishMode] <String>] [[-PublishSource] <String>] [[-PublishTargets] <String>] [[-PublishLanugages] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](Install-ScSerializationPackage.md)
##  Install-Sitecore
Installs Sitecore with the correct version to the WebRoot    
    
    Install-Sitecore [-Backup] [-Force] [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Install-Sitecore.md)
##  Install-SitecorePackage
Installs the correct Sitecore distribution to a specific location.    
    
    Install-SitecorePackage [-OutputLocation] <String> [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Install-SitecorePackage.md)
##  Install-WebConfig
Transforms all Web.*.config with the Sitecore web.config and puts it to the web-root.    
    
    Install-WebConfig [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Install-WebConfig.md)
##  Install-WebConfigByFolders
Transforms all Web.*.config with the Sitecore web.config and puts it to the web-root.    
    
    Install-WebConfigByFolders [[-Folders] <String[]>] [[-ConfigPath] <String>] [[-Environment] <String>] [[-Role] <String[]>] [[-AdditionalXdtFiles] <String[]>] [<CommonParameters>]


 [Read more](Install-WebConfigByFolders.md)
##  Invoke-SqlCommand
Invokes a script block with SQL specific error handling.    
    
    Invoke-SqlCommand [-Command] <ScriptBlock> [<CommonParameters>]


 [Read more](Invoke-SqlCommand.md)
##  Merge-ConnectionStrings
Creates a ConnectionStrings.config by merging the file from the project and Bob.config.    
    
    Merge-ConnectionStrings [-OutputLocation] <String> [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Merge-ConnectionStrings.md)
##  New-Cert
Generates a new SSL certificate with a specific CA    
    
    New-Cert [-Name] <String> [-CA] <Object> [<CommonParameters>]


 [Read more](New-Cert.md)
##  New-CertCA
Generates a new certificate which can be used as certificate authority.    
    
    New-CertCA [-Name] <String> [<CommonParameters>]


 [Read more](New-CertCA.md)
##  Publish-ScSerializationPackage
Triggers a remote publishing job.    
    
    Publish-ScSerializationPackage [-Url] <String> [-Mode] <String> [[-Source] <String>] [[-Targets] <String>] [[-Languages] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](Publish-ScSerializationPackage.md)
##  ResolvePath
    ResolvePath [[-PackageId] <Object>] [[-RelativePath] <Object>]


 [Read more](ResolvePath.md)
##  Set-ScActiveEnvironment
Sets the active environment.    
    
    Set-ScActiveEnvironment [-Environment] <String> [<CommonParameters>]


 [Read more](Set-ScActiveEnvironment.md)
##  Set-ScActiveRole
Sets the active role (delivery or author).    
    
    Set-ScActiveRole [-Role] <String> [<CommonParameters>]


 [Read more](Set-ScActiveRole.md)
##  Set-ScSerializationReference
Sets the SerializationReference path of the current project.    
    
    Set-ScSerializationReference [[-WebPath] <String>] [[-ProjectPath] <String>] [[-SerializationPath] <String>] [[-SerializationTemplateKey] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](Set-ScSerializationReference.md)
##  Start-ScAppPool
Starts the application pool configured for the project.    
    
    Start-ScAppPool [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Start-ScAppPool.md)
##  Stop-ScAppPool
Stops the application pool configured for the project.    
    
    Stop-ScAppPool [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Stop-ScAppPool.md)
##  Sync-ScDatabases
Deserialize all items to the database.    
    
    Sync-ScDatabases [[-ProjectPath] <String>] [<CommonParameters>]


 [Read more](Sync-ScDatabases.md)
##  Update-Sitecore
Updates all NuGet packages of Sitecore to a new version.    
    
    Update-Sitecore [-Version] <String> [<CommonParameters>]


 [Read more](Update-Sitecore.md)
##  Initialize-Environment
Performs all actions required on the local system to get started with a new project.    
    
    Initialize-Environment [<CommonParameters>]


 [Read more](Initialize-Environment.md)

