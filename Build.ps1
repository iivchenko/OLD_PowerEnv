Param([switch]$Sign)

$source = ".\PowerEnv\"
$binaries = ".\bin"
$signtool = "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe"

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

if ($Sign)
{
    $list = Get-ChildItem -Path $binaries -Recurse -File -Include *.ps1 | % { $_.FullName }

    & $signtool sign /v /f .\Certificates\PowerEnv.pfx $list
}