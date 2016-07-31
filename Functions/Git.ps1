function Git-GetPath
{
    return Env-Read -Property GitExePath
}

function Git-SetPath
{
    Param
    (
        [Parameter(Mandatory=$true)]
	    [string]$Path        
    )
    
    Env-Write -Property GitExePath -Value $Path
}

<#
.SYNOPSIS    
    Run git commands on specified paths. If paths are not specified all directories from the execution paths will be used.
#>
function Git-DoAll
{
	Param
	(
		[Parameter(Mandatory=$true)]
		[string[]]$Commands,
		[string[]]$Paths
	)
	
	$git = Git-GetPath
	
	if(-not(Test-Path -Path $git -PathType Leaf))
	{
		Write-Error "Invalid git.exe path: '$git'"
		return
	}
	
	$workDir = (Get-Location).Path
	
	if(($Paths -eq $null) -OR ($Paths.Count -eq 0))
	{
		$Paths = Get-ChildItem -Directory
	}
	
	foreach($path in $Paths)
	{
		if(-not(Join-Path -Path $path -ChildPath ".git" | Test-Path ))
		{		    
			Write-Verbose "Path: '$path' is not a git repository."
			continue
		}
		
		Set-Location $path
			
		foreach($command in $commands) 
		{
		    Write-Host
			Write-Host "Repository: " -ForegroundColor Yellow -NoNewLine
			Write-Host $path -ForegroundColor Green		
			Write-Host "Command: " -ForegroundColor Yellow -NoNewLine
			Write-Host $command -ForegroundColor Cyan; & $git $command.Split(' ') 
		}
		
		Set-Location $workDir
	}
}