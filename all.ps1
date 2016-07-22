param ([string[]]$commands)

$git = "C:\Program Files (x86)\Git\bin\"

$repos = ("common", "crypto", "mr", "o3e-packaging", "replay")

$repos | % { Set-Location $_; Write-Host $_ -ForegroundColor Green; $commands | % { Write-Host $_ -ForegroundColor Cyan; & git $_.Split(' ') }; Set-Location ..; }

