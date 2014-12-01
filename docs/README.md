# Scoop

##  Copy-UnmanagedFiles

Copy-UnmanagedFiles [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Copy-UnmanagedFiles; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Copy-UnmanagedFiles.md)
##  Enable-ScSite
Creates the IIS Site and IIS Application Pool for the current Sitecore Website project.

    Enable-ScSite [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](api/Enable-ScSite.md)
##  Get-ScProjectRootPath
Traverses directories, starting with the project directory, testing for a RootIdentifier.

    Get-ScProjectRootPath [[-ProjectPath] <String>] [[-RootIdentifier] <String>] [[-stopString] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](api/Get-ScProjectRootPath.md)
##  GetSqlExcpetion

GetSqlExcpetion [[-ex] <Object>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=GetSqlExcpetion; CommonParameters=False; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/GetSqlExcpetion.md)
##  Import-ScDatabases
Restores all Databases of a project from a file share.

    Import-ScDatabases [[-ConnectionStringsFile] <String>] [[-VSProjectRootPath] <String>] [[-ProjectRootPath] <String>] [[-DatabasePath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](api/Import-ScDatabases.md)
##  Initialize-Environment

Initialize-Environment [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Initialize-Environment; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Initialize-Environment.md)
##  Install-Sitecore

Install-Sitecore [-Backup] [-Force] [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Install-Sitecore; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Install-Sitecore.md)
##  Install-SitecorePackage

Install-SitecorePackage [-OutputLocation] <string> [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Install-SitecorePackage; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Install-SitecorePackage.md)
##  Merge-ConnectionStrings

Merge-ConnectionStrings [-OutputLocation] <string> [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Merge-ConnectionStrings; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Merge-ConnectionStrings.md)
##  ResolvePath

ResolvePath [[-PackageId] <Object>] [[-RelativePath] <Object>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=ResolvePath; CommonParameters=False; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/ResolvePath.md)
##  Set-ScActiveRole

Set-ScActiveRole [-Role] <string> [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Set-ScActiveRole; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Set-ScActiveRole.md)
##  Set-ScSerializationReference
Sets the SerializationReference path of the current project.

    Set-ScSerializationReference [[-ProjectRootPath] <String>] [[-WebPath] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]


 [Read more](api/Set-ScSerializationReference.md)
##  Initialize-Environment

Initialize-Environment [<CommonParameters>]


    syntaxItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    ----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

    {@{name=Initialize-Environment; CommonParameters=True; WorkflowCommonParameters=False; parameter=System.Object[]}}


 [Read more](api/Initialize-Environment.md)

