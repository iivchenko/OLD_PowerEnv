<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

Clear-Host

Write-Host "`nCopyright (c) 2016 by Shogun, All Right Reserved`nDon't be shy just enjoy with PowerEnv =)`n" -ForegroundColor Green

# Set working directory.
# Env-Read -Property WorkingDir | Set-Location

# Provide direct access to scripts.
$scriptsPath = (Get-Item "$PSScriptRoot\Scripts").FullName
$env:Path = "$env:Path;$scriptsPath"

# Load functions to the global scope.
# Functions must be marked with global scope.
Get-ChildItem "$PSScriptRoot\Functions" | % { & $_.FullName }

# Set useful aliaces.
# Set-Alias -Name edit -Scope Global -Value (Env-Read NotepadPlusPath)

