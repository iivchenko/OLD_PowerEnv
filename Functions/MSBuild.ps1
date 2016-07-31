<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

function global:MSBuild-GetPath
{
    return Env-Read -Property MSBuildExePath
}

function global:MSBuild-SetPath
{
    Param
    (
        [Parameter(Mandatory=$true)]
	    [string]$Path        
    )
    
    Env-Write -Property MSBuildExePath -Value $Path
}