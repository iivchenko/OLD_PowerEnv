<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

function global:Choco-Install
{
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function global:Choco-Git
{
    @("poshgit") | % { choco install $_ -y }
}

function global:Choco-Work
{
    @("notepadplusplus", "7zip", "doublecmd", "rdcman", "paint.net") | % { choco install $_ -y }
}