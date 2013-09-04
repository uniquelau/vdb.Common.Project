vdb.Common.Project
==================

Empty Project for Umbraco Website

## Git
### [.gitattributes](.gitattributes)

This file makes sure that git treats your files right. Different operating systems and softwares deal with line endings in different ways. It's important these are consistant across your files as otherwise Git may pick these differences up as 'modifications' on the orginal file.

This file is based on the default file that is created when making a Team Foundation Service git repo.

[Mind that line](http://timclem.wordpress.com/2012/03/01/mind-the-end-of-your-line/)
[Dealing with line-endings](https://help.github.com/articles/dealing-with-line-endings)

### [.gitignore](.gitignore)

The root of the repository contains a general .gitignore file. This file ignores Visual Studio and Operating System temp files. 

#### [Umbraco .gitignore](VS.NET/company.project.Web/.gitignore)

In addition there is also a .gitignore file that is tailored for the Umbraco Web Application. This .gitignore file should be placed inside the directory that contains the Umbraco application. This file will ignore Umbraco temp files created by a variety of popular packages.

## Visual Studio 

### [VS.NET](VS.NET)

The VS.NET folder contains a set of useful preconfigured files and conventions that can be used as starting point in your projects. 

#### [Company.Project.Web](VS.NET/company.project.Web)

This folder will contain your Umbraco application. You will need to rename the files to match your project (e.g. Company.Project becomes tescos.Jobs)



### NuGet

NuGet can be used to easily install packages into Visual Studio projects.

In this project configuration these files are not included in Source Control, as they NuGet is able to automatically download these files on project build.

This avoids clogging the repository up with files that should not be under source control.

You will however need to **enable 'package restore'** inside Visual Studio. This adds a series of tasks into your solution that will automatically find and install the required packages.

+ Right click on the solution in the Solution Explorer and select 'Enable Package Restore'

This will update/create:

+ NuGet folder containing the required NuGet files
+ A solution folder, showing these files within Visual Studio
+ Each projects *.csproj file is updated to include the Nuget.targets file

References
==================

Taylor Smith, [.gitignore gist](https://gist.github.com/taylorsmith/2883529)

Recommended reading
==================

Sayed I Hashimi &amp; William Bartholomew, [Using MSBuild and Team Foundation Build](http://msbuildbook.com/)  
Sayed I Hashimi &amp; William Bartholomew, [MSBuild Supplement](http://msbuildbook.com/)  
