Param
(
    [switch]$Sign,
    
    [Parameter(ParameterSetName='Build', Mandatory=$true)]
    [string]$Configuration="Release",

    [Parameter(ParameterSetName='NoBuild')]
    [switch]$NoBuild
)

$source = ".\PowerEnv\"
$binaries = ".\bin"
$signtool = "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe"
$msb = "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"

if (-not(Test-Path -Path $source -PathType Container))
{
    Write-Error "$source path is missing!!"
    return
}

if (Test-Path -Path $binaries -PathType Container)
{
    Remove-Item -Path $binaries -Recurse -Force
}

New-Item -Path $binaries -ItemType Directory | Out-Null

Copy-Item -Path $source -Destination $binaries -Recurse -Force

# Sign scripts
if ($Sign)
{
    $list = Get-ChildItem -Path $binaries -Recurse -File -Include *.ps1 | % { $_.FullName }

    & $signtool sign /v /f .\Certificates\PowerEnv.pfx $list
}

# Build installer
if (-not($NoBuild))
{
    Write-Host "Building installer" -ForegroundColor Green
	
    & $msb .\PowerEnv.sln /nologo /m /consoleloggerparameters:ErrorsOnly /verbosity:q /t:Rebuild /p:Configuration=$Configuration /property:Platform=x86
	
    if ($LASTEXITCODE -ne 0)
    {
	    Write-Host "Installer build Fail" -ForegroundColor Red -BackgroundColor Black
    }
    else
    {
	    Write-Host "Installer build Succeded" -ForegroundColor Green
    }
}