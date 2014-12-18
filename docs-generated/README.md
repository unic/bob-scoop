# Scoop

As with his front and rear shovels (scoops), Scoop provides a PSH based toolset for developers using Visual Studio.

Scoop is resposible for the following tasks.

* Configure IIS for the current Project
* Install sitecore
* Set serialization reference
* Import databases

Running all this tasks in a sequence can be done by running the following command in the "Package Manager Console"

    bump

## Install Scoop
Scoop can be installed by running the following command in the "Package Manager Console"
    
    Install-Package Unic.Bob.Scoop

## Module development

Scoop can also be used in Modules. The installation is the same as for Websites. Make sure you configure the WebRoot key in Bob.config is set.

Currently `Set-ScSerializationReference` ist the only command suposed to be used in modules.
