Function Fetch ($repo)
{
    if (-not(Test-Path -Path "$PSScriptRoot\$repo"))
    {
        Write-Warning "There is no repository $repo."
        return;
    }

    Write-Host -Object "Fetching $repo" -ForegroundColor Green
    Set-Location "$PSScriptRoot\$repo"
    git remote | % { Write-Host -Object "      Fetching $_" -ForegroundColor Green; git fetch $_; }
}

$pattern = "*C:\Program Files (x86)\Git\bin\*"
$git = "C:\Program Files (x86)\Git\bin\"

$PATH = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

if(-not($PATH -like $pattern))
{
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$git", [EnvironmentVariableTarget]::Machine);
}

git config --global credential.helper wincred

Fetch "common"
Fetch "mr"
Fetch "replay"
Fetch "crypto"
Fetch "o3e-packaging"

Set-Location "$PSScriptRoot"

git config --global --unset credential.helper
