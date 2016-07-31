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