<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

# Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

$apps = @("poshgit", "notepadplusplus", "7zip", "doublecmd", "rdcman", "sysinternals", "paint.net")

$apps | % { choco install $_ -y}