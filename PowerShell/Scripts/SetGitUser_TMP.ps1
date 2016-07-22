function SetCreds($path)
{
	if (Test-Path -Path $path)
	{
		 Set-Location $path
	
		git config --local user.name "iivchenko"
		git config --local user.email ivan.ivchenko@software.dell.com
		
		Write-Host "Set credential for $path" -ForegroundColor Green
		
		Set-Location $PSScriptRoot
	}
	else
	{
		Write-Host "$path doesn't exist!'" -ForegroundColor Green
	}
}

$Common = "common"
$Crypto = "crypto"
$Mr = "mr"
$O3ePackaging = "o3e-packaging"
$Replay = "replay"

SetCreds -Path $Common 
SetCreds -Path $Crypto
SetCreds -Path $Mr
SetCreds -Path $O3ePackaging
SetCreds -Path $Replay