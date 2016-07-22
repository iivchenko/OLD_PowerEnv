# Just a simple helper git script. 
# Add a git path to the System variable so posh-git could work (do it only once)
# Run posh-git

$pattern = "*C:\Program Files (x86)\Git\bin\*"
$git = "C:\Program Files (x86)\Git\bin\"

$PATH = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

if(-not($PATH -like $pattern))
{
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$git", [EnvironmentVariableTarget]::Machine);
}


& "$PSScriptRoot\..\Modules\posh-git\profile.example.ps1"
& "$PSScriptRoot\aliases.ps1"

