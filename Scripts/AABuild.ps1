<#
.SYNOPSIS    
    Build Fucking AppAssure projects and solutions

.DESCRIPTION
    - The script uses MSBuild.exe and the scrip has direct link to the exe module.
    - Before using the script specify MSBuild.exe path using MSBuild-SetPath function.
    - Run script with Administrators rights

.PARAMETER Projects
    Specify list of AppAssure projects or solutions you want to build. By default all projects and solutions will be build.

.PARAMETER Configurations
    Specify list of Configurations you want your projects and solutions to be build. By default all configurations will be used.

.PARAMETER Platforms
    Specify list of Platforms you want your projects and solutions to be build. By default all platforms will be used.

.PARAMETER Path
    Specify path where AppAssure repositories are placed. By default path where the script is running will be used.

.PARAMETER NoLogo
    Use the switch if you don't want to see the cool logo.

.EXAMPLE
    .\AABuild.ps1

    Build all AppAssure projects in all Configurations and Platforms. Project paths will be relative to the path where script is executing.

.EXAMPLE
    .\AABuild.ps1 -Path c:\AASources

    Build all AppAssure projects in all Configurations and Platforms. Project paths will be relative to the path c:\AASources.


.EXAMPLE
    .\AABuild.ps1 -Configurations debug -Platforms x64,"Any Cpu"

    Build all AppAssure projects in debug Configurations. Some of them in x64 and others in Any CPU Platforms. Project paths will be relative to the path where script is executing.

.EXAMPLE
    .\AABuild.ps1 -NoLogo

    Build all AppAssure projects in all Configurations and Platforms but without cool LOGO. Project paths will be relative to the path where script is executing.

.EXAMPLE
    .\AABuild.ps1 -Projects gmock

    Build gmock solution in all Configurations and Platforms. gmock path will be relative to the path where script is executing.

.EXAMPLE
    .\AABuild.ps1 -Projects gmock,cppunit -Configurations release

    Build gmock and cppunit solutions in release Configuration and for all Platforms. Project paths will be relative to the path where script is executing.

.EXAMPLE
    .\AABuild.ps1 -Projects gmock -Configurations release -Platforms x64

    Build gmock and cppunit solutions in release Configuration and for x64 Platform only. gmock path will be relative to the path where script is executing.
#>
Param
    (
	  [string[]]$Projects,
      [string[]]$Configurations,
      [string[]]$Platforms,
      [string]$Path,
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
$msb = MSBuild-GetPath

if(-not(Test-Path $msb -PathType Leaf))
{
    Write-Error "Invalid MSBuild.exe path: '$msb'"
    return
}

function Build([Project] $project, [string] $root)
{
	$name          = $project.Name
    $configuration = $project.Configuration
    $platform      = $project.Platform

    if ($root)
    {
        $path = Join-Path -Path $root -ChildPath $project.Path
    }
    else
    {
        $path = Join-Path -Path . -ChildPath $project.Path        
    }    
	
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
                [Project]@{ Name = "gmock"; 					Configuration = "release"; Platform ="x64";   	Path = "common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "debug";   Platform ="x64";   	Path = "common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "release"; Platform ="win32"; 	Path = "common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                [Project]@{ Name = "gmock"; 					Configuration = "debug";   Platform ="win32"; 	Path = "common\tools\gmock-1.4.0\msvc\gmock.sln"; },
                
                # cppunit
                [Project]@{ Name = "cppunit";   				Configuration = "release"; Platform ="x64";		Path = "common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                [Project]@{ Name = "cppunit";					Configuration = "debug";   Platform ="x64";		Path = "common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                [Project]@{ Name = "cppunit";   				Configuration = "release"; Platform ="win32"; 	Path = "common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },                
                [Project]@{ Name = "cppunit";					Configuration = "debug";   Platform ="win32"; 	Path = "common\tools\cppunit-1.12.0\cppunit-1.12.0.sln"; },
                
                # WCFClientGenerator
                [Project]@{ Name = "wcfclientgenerator";        Configuration = "release"; Platform ="any cpu"; Path = "common\tools\WCFClientGenerator\WCFClientGenerator.sln"; },
                [Project]@{ Name = "wcfclientgenerator";      	Configuration = "debug";   Platform ="any cpu"; Path = "common\tools\WCFClientGenerator\WCFClientGenerator.sln"; },

                # DatabaseClientGenerator
                [Project]@{ Name = "databaseclientgenerator";  	Configuration = "release"; Platform ="any cpu";	Path = "common\tools\DatabaseClientGenerator\DatabaseClientGenerator.sln"; },
                [Project]@{ Name = "databaseclientgenerator";  	Configuration = "debug";   Platform ="any cpu";	Path = "common\tools\DatabaseClientGenerator\DatabaseClientGenerator.sln"; },

                # Libtomcrypt
                [Project]@{ Name = "libtomcrypt";               Configuration = "release"; Platform ="x64"; Path = "common\Libtomcrypt\libtomcrypt.sln"; },
				[Project]@{ Name = "libtomcrypt";               Configuration = "release"; Platform ="win32"; Path = "common\Libtomcrypt\libtomcrypt.sln"; },
                [Project]@{ Name = "libtomcrypt";               Configuration = "debug";   Platform ="x64"; Path = "common\Libtomcrypt\libtomcrypt.sln"; },
				[Project]@{ Name = "libtomcrypt";               Configuration = "debug";   Platform ="win32"; Path = "common\Libtomcrypt\libtomcrypt.sln"; },

                # crypto
                [Project]@{ Name = "crypto";                    Configuration = "release"; Platform ="x64";    	Path = "crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "debug";   Platform ="x64";    	Path = "crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "release"; Platform ="win32";  	Path = "crypto\backend\crypto.sln"; },
                [Project]@{ Name = "crypto";                    Configuration = "debug";   Platform ="win32"; 	Path = "crypto\backend\crypto.sln"; },
                
                # AAMsg
                [Project]@{ Name = "aamsg";                     Configuration = "release"; Platform ="x64";   	Path = "replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "debug";   Platform ="x64";   	Path = "replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "release"; Platform ="win32"; 	Path = "replay\common\AAMsg\AAMsg.sln"; },
                [Project]@{ Name = "aamsg";                     Configuration = "debug";   Platform ="win32"; 	Path = "replay\common\AAMsg\AAMsg.sln"; },
                
                # AaDiag
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="x64";   	Path = "replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="x64";   	Path = "replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="x86";   	Path = "replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="x86";   	Path = "replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "release"; Platform ="win32"; 	Path = "replay\common\AaDiag\AaDiag.sln"; },
                [Project]@{ Name = "aadiag";                    Configuration = "debug";   Platform ="win32"; 	Path = "replay\common\AaDiag\AaDiag.sln"; },
                
                # TevoLib                
                [Project]@{ Name = "tevolib";                   Configuration = "release"; Platform ="x64";   	Path = "replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "debug";   Platform ="x64";   	Path = "replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "release"; Platform ="win32"; 	Path = "replay\tevolib\TevoLib.sln"; },
                [Project]@{ Name = "tevolib";                   Configuration = "debug";   Platform ="win32"; 	Path = "replay\tevolib\TevoLib.sln"; },

                # services
                [Project]@{ Name = "services";                  Configuration = "release"; Platform ="x64"; 	Path = "replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "debug";   Platform ="x64"; 	Path = "replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "release"; Platform ="win32"; 	Path = "replay\services\services.sln "; },
                [Project]@{ Name = "services";                  Configuration = "debug";   Platform ="win32"; 	Path = "replay\services\services.sln "; }    
            )

# === Actually Build Script ===
if (-not($NoLogo))
{
    $logo  = "#=============================#"; $logo += "`n"    
    $logo += "# Build all Fucking AppAssure #"; $logo += "`n"
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
    Build -project $project -root $Path
    Write-Host
}

$end = Get-Date
$time = $end - $start

Write-Host "Time: $time" -ForegroundColor Cyan