function MSBuild-GetPath
{
    return Env-Read -Property MSBuildExePath
}

function MSBuild-SetPath
{
    Param
    (
        [Parameter(Mandatory=$true)]
	    [string]$Path        
    )
    
    Env-Write -Property MSBuildExePath -Value $Path
}