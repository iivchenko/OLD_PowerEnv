$apps=("rdcman", "7zip", "notepadplusplus")

# Install chocolatey app
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install apps that I need with chocolatey
foreach ($app in $apps)
{
    choco install $app -y --force
}