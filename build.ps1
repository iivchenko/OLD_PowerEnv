#=============================#
# Build all Fucking AppAssure #
# Verson: 0.4                 #
# Author: Ivan Ivchenko       #
#=============================#


# Micro Tracker
# 
# Release v 1.0 =
# x_x 0.5   [F] - Implement parallel builds for the same project but in differrent configurations
#     0.5   [F] - Add help, check script header, check all the spelling, refactor code, add samples
#           [F] - Add input paramete to customize base directory
#           [F] - Add ability to specify verbosity
#           [F] - Add -List switch to show availbale projects, names, platforms, Configurations
#
# Future Releases
# [F] - Add ability to write log file (XML format with devided projects into separate <tags>)
# [F] - Add enums for Platform, Configuration, Project name so it will be possible to use some kind 
#       of intellisense. But it could be implemented only on MODULE (AppAssureDev) level.

<#
.SYNOPSIS    
    Build Fucking AppAssure projects and solutions

.DESCRIPTION
    1. Place your script on the level of AppAssure repositories among common, mr, replay, etc folders.
    2. The script uses MSBuild.exe and the scrip has direct link to the exe module. So if you have no MSBuild or script doesn't point to it so just install MSBuild or modify the script.
    3. Run script with Administrators rights

.PARAMETER Projects
    Specify list of AppAssure projects or solutions you want to build. By default all projects and solutions will be build.

.PARAMETER Configurations
    Specify list of Configurations you want your projects and solutions to be build. By default Configurations will be used.

.PARAMETER Platforms
    Specify list of Platforms you want your projects and solutions to be build. By default Platforms will be used.

.PARAMETER NoLogo
    Use the switch if you don't want to see the cool logo.

.EXAMPLE
    .\build.ps1

    Build all AppAssure projects in all Configurations and Platforms.

.EXAMPLE
    .\build.ps1 -Configurations debug -Platforms x64,"Any Cpu"

    Build all AppAssure projects in debug Configurations. Some of them in x64 and others in Any CPU Platforms.

.EXAMPLE
    .\build.ps1 -NoLogo

    Build all AppAssure projects in all Configurations and Platforms but without cool LOGO.

.EXAMPLE
    .\build.ps1 -Projects gmock

    Build gmock solution in all Configurations and Platforms.

.EXAMPLE
    .\build.ps1 -Projects gmock,cppunit -Configurations release

    Build gmock and cppunit solutions in release Configuration and for all Platforms.

.EXAMPLE
    .\build.ps1 -Projects gmock -Configurations release -Platforms x64

    Build gmock and cppunit solutions in release Configuration and for x64 Platform only.
#>
Param
    (
	  [string[]]$Projects,
      [string[]]$Configurations,
      [string[]]$Platforms,
      [switch]$NoLogo
    )

# === Declarations ===
class Project
{
    [string]$Name    
    [string]$Configuration
    [string]$Platform
	[string]$Path
}

# == PATH TO THE MSBUILD.EXE ==
$msb = "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"

function Build([Project] $project)
{
	$name          = $project.Name
    $configuration = $project.Configuration
    $platform      = $project.Platform
	$path          = $project.Path
	
	Write-Host "$name $configuration $platform is building" -ForegroundColor Green
	
    & $msb $path /nologo /m /consoleloggerparameters:ErrorsOnly /verbosity:q /t:Rebuild /p:Configuration=$configuration /property:Platform=$platform
	
	if ($LASTEXITCODE -ne 0)
	{
		Write-Host "$name $configuration $platform build Fail" -ForegroundColor Red -BackgroundColor Black
	}
	else
	{
		Write-Host "$name $configuration $platform build Succeded" -ForegroundColor Green
	}
}

$allProjects=
            (
                # gmock
                [Project]@{ Name = "gmock"; 					Configuration = "release"; Platform ="x64";   	Path = ".\common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "debug";   Platform ="x64";   	Path = ".\common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "release"; Platform ="win32"; 	Path = ".\common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "debug";   Platform ="win32"; 	Path = ".\common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                
                # cppunit
                [Project]@{ Name = "cppunit";   				Configuration = "release"; Platform ="x64";		Path = ".\common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                [Project]@{ Name = "cppunit";					Configuration = "debug";   Platform ="x64";		Path = ".\common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                [Project]@{ Name = "cppunit";   				Configuration = "release"; Platform ="win32"; 	Path = ".\common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },                
                [Project]@{ Name = "cppunit";					Configuration = "debug";   Platform ="win32"; 	Path = ".\common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                
                # WCFClientGenerator
                [Project]@{ Name = "wcfclientgenerator";        Configuration = "release"; Platform ="any cpu"; Path = ".\common\tools\WCFClientGenerator\WCFClientGenerator.sln"; },
                [Project]@{ Name = "wcfclientgenerator";      	Configuration = "debug";   Platform ="any cpu"; Path = ".\common\tools\WCFClientGenerator\WCFClientGenerator.sln"; },

                # DatabaseClientGenerator
                [Project]@{ Name = "databaseclientgenerator";  	Configuration = "release"; Platform ="any cpu";	Path = ".\common\tools\DatabaseClientGenerator\DatabaseClientGenerator.sln"; },
                [Project]@{ Name = "databaseclientgenerator";  	Configuration = "debug";   Platform ="any cpu";	Path = ".\common\tools\DatabaseClientGenerator\DatabaseClientGenerator.sln"; },

                # Libtomcrypt
                [Project]@{ Name = "libtomcrypt";               Configuration = "release"; Platform ="x64"; Path = ".\common\Libtomcrypt\libtomcrypt.sln"; },
				[Project]@{ Name = "libtomcrypt";               Configuration = "release"; Platform ="win32"; Path = ".\common\Libtomcrypt\libtomcrypt.sln"; },
                [Project]@{ Name = "libtomcrypt";               Configuration = "debug";   Platform ="x64"; Path = ".\common\Libtomcrypt\libtomcrypt.sln"; },
				[Project]@{ Name = "libtomcrypt";               Configuration = "debug";   Platform ="win32"; Path = ".\common\Libtomcrypt\libtomcrypt.sln"; },

                # crypto
                [Project]@{ Name = "crypto";                    Configuration = "release"; Platform ="x64";    	Path = ".\crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "debug";   Platform ="x64";    	Path = ".\crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "release"; Platform ="win32";  	Path = ".\crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "debug";   Platform ="win32"; 	Path = ".\crypto\backend\crypto.sln"; },
                
                # AAMsg
                [Project]@{ Name = "aamsg";                     Configuration = "release"; Platform ="x64";   	Path = ".\replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "debug";   Platform ="x64";   	Path = ".\replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "release"; Platform ="win32"; 	Path = ".\replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "debug";   Platform ="win32"; 	Path = ".\replay\common\AAMsg\AAMsg.sln"; },
                
                # AaDiag
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="x64";   	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="x64";   	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="x86";   	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="x86";   	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="win32"; 	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="win32"; 	Path = ".\replay\common\AaDiag\AaDiag.sln"; },
                
                # TevoLib                
                [Project]@{ Name = "tevolib";                   Configuration = "release"; Platform ="x64";   	Path = ".\replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "debug";   Platform ="x64";   	Path = ".\replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "release"; Platform ="win32"; 	Path = ".\replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "debug";   Platform ="win32"; 	Path = ".\replay\tevolib\TevoLib.sln"; },

                # services
                [Project]@{ Name = "services";                  Configuration = "release"; Platform ="x64"; 	Path = ".\replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "debug";   Platform ="x64"; 	Path = ".\replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "release"; Platform ="win32"; 	Path = ".\replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "debug";   Platform ="win32"; 	Path = ".\replay\services\services.sln "; }    
            )

# === Actually Build Script ===
if (-not($NoLogo))
{
    $logo  = "#=============================#"; $logo += "`n"    
    $logo += "# Build all Fucking AppAssure #"; $logo += "`n"
    $logo += "# Verson: 0.4                 #"; $logo += "`n"
    $logo += "# Author: Ivan Ivchenko       #"; $logo += "`n"
    $logo += "#=============================#"; $logo += "`n"

    Write-Host $logo -ForegroundColor Cyan
}

$start = Get-Date

# Check input project Names
$allNames = $allProjects | % { $_.Name } | Sort-Object | Get-Unique

if ($Projects -eq $Null)
{
	$Projects = $allNames
}
else
{
	$Projects = $Projects | % { $_.ToLower() }

	$unknown = $Projects | where { !$allNames.Contains($_) }
	
	if ($unknown -ne $Null)
	{
		throw "Unknown projects '$unknown'"
	}	
}

# Check input project Configurations
$allConfigurations = $allProjects | % { $_.Configuration } | Sort-Object | Get-Unique

if ($Configurations -eq $Null)
{
	$Configurations = $allConfigurations
}
else
{
	$Configurations = $Configurations | % { $_.ToLower() }

	$unknown = $Configurations | where { !$allConfigurations.Contains($_) }
	
	if ($unknown -ne $Null)
	{
		throw "Unknown configurations '$unknown'"
	}	
}

# Check input project Platforms
$allPlatforms = $allProjects | % { $_.Platform } | Sort-Object | Get-Unique

if ($Platforms -eq $Null)
{
	$Platforms = $allPlatforms
}
else
{
	$Platforms = $Platforms | % { $_.ToLower() }

	$unknown = $Platforms | where { !$allPlatforms.Contains($_) }
	
	if ($unknown -ne $Null)
	{
		throw "Unknown platforms '$unknown'"
	}	
}

# Select projects for build
$tobuild = $allProjects | where { $Projects.Contains($_.Name) } | where { $Configurations.Contains($_.Configuration) } | where { $Platforms.Contains($_.Platform) }

# Build
foreach ($project in $tobuild)
{
    Build -project $project
    Write-Host
}

$end = Get-Date
$time = $end - $start

Write-Host "Time: $time" -ForegroundColor Cyan