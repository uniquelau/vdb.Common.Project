# Readme
## [Umbraco](Umbraco)
### Document Type Icons

/Umbraco/Images/Umbraco

Document Type icons named by document type alias. One to one relationship.
Can be wired up automatically using AutoIcons package.

## .targets
The targets files modify the default Visual Studio build behaviours. 

Normally these would be inside the .csproj file, however maintaining the .csproj file can difficult. To make this process easier we have created seperated targets files which are automatically imported into the *.csproj. This gives clear seperation between what Visual Studio creates for you and your own custom code. 

This also follows a new Visual Studio pattern were 'web publishing profile' (wpp) targets are automatically imported using the following convention. 

+ Project Name: company.project
+ Web Publishing Profile: company.project.wpp.targets

Visual Studio will not automatically import the other .targets file. So you have to make a slight adjustment to your .csproj file. Paste the following code before the closing </Project> to import the general build targets.

    <!-- Bespoke Tailored Code-->
    <Import Project="company.project.Web.targets" />
	
Remember to rename the targets files to match your project. 

In an ideal world this would be set to

    $(MSBuildProjectName)
	
However TeamCity has a bug, where by it gets the wrong name for the reserved MSBuild parameter.

## Project Build Configuration

It is strongly recommended to use a common build path when working with Umbraco. This gives seperation between the binaries used in your own project, and then binaries that make up the Umbraco /Bin. This apporach can also be used to considerably improve build performance. 

In each visual studio project, update the Output Path, to:

../output/(Configuration)/

../output/Debug/
../output/Release/

*** This translates as, go up a directory to the parent of the project, and then place the build output inside 'output' \ 'configuration' ***

The build scripts included in this project will copy the latest project DLL's into the Umbraco web application each time the project builds. These are always copied from the corresponding 'Configuration' folder ensuring the DLL's are correct. 

There is a bug inside Visual Studio 2010, which creates an additional /Bin folder inside the /Output directory. This can be ignored. By default this direction is ignored, as binaries should not be sourced controlled.

### Project References

When referencing projects, it is preferrable to avoid directly referencing the DLL, instead use a 'project reference'. It is **very** important that 'Copy Local' is set to False. 

[Nancy on CopyLocal=True](http://codebetter.com/patricksmacchia/2013/05/30/a-typical-effect-of-setting-copylocal-true/)

## [XSLT](Xslt)

Contains XSLT templates for creating navigation in websites.
These are sourced from [Greystates XSLT Helpers](https://github.com/greystate/Greystate-XSLT-Helpers) and have been modified to support:
+ MNTP for picking navigation items (mode = multinode, property = propertyContainingMntp)
+ Support for 'Redirect' document type
+ Ancestor class on nested navigation to make styling easier
