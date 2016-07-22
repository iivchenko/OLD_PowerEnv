# Aliases for soft I usualy use

Set-Alias -Name vs   -Scope Global -Value "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
Set-Alias -Name edit -Scope Global -Value "C:\Program Files (x86)\Notepad++\notepad++.exe"

Set-Variable -Name _User    -Scope Global -Option ReadOnly -Value ([Environment]::UserName)
Set-Variable -Name _Skype   -Scope Global -Option ReadOnly -Value "C:\Users\$User\AppData\Roaming\Skype\My Skype Received Files\"
Set-Variable -Name _Sources -Scope Global -Option ReadOnly -Value "D:\Sources"