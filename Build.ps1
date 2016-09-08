Param
(
	[switch]$Sign,
        
	[switch]$Build
)

$source = ".\PowerEnv"
$binaries = ".\bin"
$packages = ".\packages"
$signtool = "$packages\signtool.exe"

# msi 
$installePath = ".\PowerEnv.Installer"
$installeProj = "$installePath\PowerEnv.wxs"
$installObj = "$binaries\Installer\PowerEnv.wixobj"
$msi = "$binaries\Installer\PowerEnv.msi"
$wix = "$packages\WiX.3.10.3"
$candle = "$wix\tools\candle.exe"
$light = "$wix\tools\light.exe"

# nuget
$nuget = "$packages\nuget.exe"
$nugetLink = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

function Setup()
{
	Write-Host
	Write-Host "Setup" -ForegroundColor Green
	
	if (-not(Test-Path -Path $source -PathType Container))
	{
		Write-Error "$source path is missing!!"
		return
	}

	if (Test-Path -Path $binaries -PathType Container)
	{
		Remove-Item -Path $binaries -Recurse -Force
	}

	New-Item -Path $binaries -ItemType Directory
	
	if (-not(Test-Path -Path $packages -PathType Container))
	{
		New-Item -Name $packages -Item Directory
	}
	
	if(-not(Test-Path -Path $nuget -PathType Leaf))
	{
		Import-Module BitsTransfer
		Start-BitsTransfer -Source $nugetLink -Destination $nuget -Verbose
	}

	& $nuget restore packages.config -PackagesDirectory packages
	
	if ($LASTEXITCODE -ne 0)
	{
		Write-Host "Setup Fail" -ForegroundColor Red -BackgroundColor Black
	}
	else
	{
		Write-Host "Setup Succeded" -ForegroundColor Green
	}
}

function BuildMsi()
{
	Write-Host
	Write-Host "Building installer" -ForegroundColor Green
	
	& $candle $installeProj -ext WixIIsExtension.dll -ext WixUIExtension.dll -out $installObj
	& $light $installObj -ext WixIIsExtension.dll -ext WixUIExtension.dll -b $installePath -out $msi
	
	if ($LASTEXITCODE -ne 0)
	{
		Write-Host "Installer build Fail" -ForegroundColor Red -BackgroundColor Black
	}
	else
	{
		Write-Host "Installer build Succeded" -ForegroundColor Green
	}
}

function Sign()
{
	Write-Host
	Write-Host "Signing scripts" -ForegroundColor Green

	$list = Get-ChildItem -Path $binaries -Recurse -File -Include *.ps1 | % { $_.FullName }

    & $signtool sign /v /f .\Certificates\PowerEnv.pfx $list
	
	if ($LASTEXITCODE -ne 0)
	{
		Write-Host "Sign Fail" -ForegroundColor Red -BackgroundColor Black
	}
	else
	{
		Write-Host "Sign Succeded" -ForegroundColor Green
	}	
}

#########################################################
#                  Actually Script                      #
#########################################################

# Prepare Environment
Setup

# Copy Scripts
Copy-Item -Path $source -Destination $binaries -Recurse -Force

# Sign scripts
if ($Sign)
{
	Sign
}

# Build MSI
if ($Build)
{
	BuildMsi
}