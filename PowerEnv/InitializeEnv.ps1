<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

Clear-Host

Write-Host "`nCopyright (c) 2016 by Shogun, All Right Reserved`nDon't be shy just enjoy with PowerEnv =)`n" -ForegroundColor Green

# Provide direct access to scripts.
$scriptsPath = (Get-Item "$PSScriptRoot\Scripts").FullName
$env:Path = "$env:Path;$scriptsPath"

# Load functions to the global scope.
# Functions must be marked with global scope.
Get-ChildItem "$PSScriptRoot\Functions" | % { & $_.FullName }

# Set useful aliaces.
# But first set notepad++ binaries path manualy. Example: Env-Write -Property NotepadPlusPath -Value "C:\Program Files (x86)\Notepad++\notepad++.exe"
# Set-Alias -Name edit -Scope Global -Value (Env-Read NotepadPlusPath)
# Set-Alias -Name win -Scope Global -Value "explorer.exe"

# Set Executable paths manualy
# Git: Env-Write -Property GitExePath -Value "C:\Program Files\Git\bin\git.exe"
# MSBuild: Env-Write -Property MSBuildExePath -Value "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"

# Set working directory.
# But first set path manualy. Example: Env-Write -Property WorkingDir -Value "D:\Sources\"
# Env-Read -Property WorkingDir | Set-Location

