#Requires -RunAsAdministrator

#PowerShell script to create self-signed certificate for signing code
$makecert = "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\makecert.exe"
$pvk2pfx = "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\pvk2pfx.exe"
$certutil = "C:\Windows\System32\certutil.exe"

$year = (Get-Date).Year
$author = "Shogun"

& $makecert -r -pe -n "CN = PowerEnv Root CA; OU = Copyright (c) $year $author" -ss CA -sr CurrentUser -a sha256 -cy authority -sky signature -sv PowerEnvRoot.pvk PowerEnvRoot.cer
& $certutil -user -addstore Root PowerEnvRoot.cer
& $makecert -pe -n "CN=PowerEnv Code Sign; OU = Copyright (c) $year $author" -a sha256 -cy end -sky signature -ic PowerEnvRoot.cer -iv PowerEnvRoot.pvk -sv PowerEnv.pvk PowerEnv.cer
& $pvk2pfx -pvk PowerEnv.pvk -spc PowerEnv.cer -pfx PowerEnv.pfx # This one we realy need