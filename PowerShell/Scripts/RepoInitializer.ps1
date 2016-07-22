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
	
$cryptoScript = 
{
	param ($workDir, $repo, $user, $pass)	
	
	if (Test-Path "$workDir\$repo")
	{
		Write-Warning "$workDir\$repo directory already exists!"
		return;
	}

	git init $workDir\$repo
	Set-Location $workDir\$repo
	git remote add gold "https://$user`:$pass@github.com/Dell-AppAssure/$repo.git"
	git fetch gold
	git checkout -b develop gold/develop
	git remote remove gold
	git remote add gold  "https://github.com/Dell-AppAssure/$repo.git"
}

$PATH = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

if(-not($PATH -like $pattern))
{
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$git", [EnvironmentVariableTarget]::Machine);
}

# Main Block
$credentials = Get-Credential
$user = ($credentials.GetNetworkCredential()).UserName
$pass = ($credentials.GetNetworkCredential()).Password

Start-Job -Name "AACommon" -ArgumentList $PSScriptRoot, "common", $user, $pass -scriptblock $cryptoScript
Start-Job -Name "AACrypto" -ArgumentList $PSScriptRoot, "crypto", $user, $pass -scriptblock $cryptoScript
Start-Job -Name "AAMr" -ArgumentList $PSScriptRoot, "mr", $user, $pass -scriptblock $cryptoScript
Start-Job -Name "AAo3e-packaging " -ArgumentList $PSScriptRoot, "o3e-packaging ", $user, $pass -scriptblock $cryptoScript
Start-Job -Name "AAReplay" -ArgumentList $PSScriptRoot, "replay", $user, $pass -scriptblock $cryptoScript

Get-Job | Where Name -like "AA*" | Wait-Job
Get-Job | Where Name -like "AA*" | Receive-Job