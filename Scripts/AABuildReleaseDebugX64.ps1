<# 
	Copyright (c) 2016 by Shogun, All Right Reserved
	Author: Ivan Ivchenko
	Email: iivchenko@live.com
#>

Param([string] $Path)

AABuild.ps1 -Configurations Release,Debug -Platforms x64,"any cpu" -Path $Path