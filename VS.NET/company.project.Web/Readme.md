# Readme
## Umbraco
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