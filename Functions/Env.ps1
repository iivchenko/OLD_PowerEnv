function global:ConfigPath
{
    return (Get-Item $PSScriptRoot).Parent.FullName + "\PowerEnv.config"
}

<#
.SYNOPSIS    
    Writes property to the PowerEnv.config file.

.DESCRIPTION
    If property exists it will be reweriten. If file doesn't exist it will be created.

.PARAMETER Property
    Name of the property to save.

.PARAMETER Value
     Value for the property to save.

.EXAMPLE
    Env-Write -Propery age -Value 55

    Writes property with the name 'age' and value '55'
#>
function global:Env-Write 
{
    Param
    (
        [Parameter(Mandatory=$true)]
	    [string]$Property,
        
        [Parameter(Mandatory=$true)]
        [string]$Value
    )
    
    $configPath = ConfigPath
    
    if (Test-Path $configPath)
    {
        $settigns = Import-Clixml -Path $configPath        
    }
    else
    {
        $settigns = @{}
    }

    if($settigns.Contains($Property))
    {
        $settigns[$Property] = $Value
    }
    else
    {
        $settigns.Add($Property, $Value)
    }

    $settigns | Export-Clixml -Path $configPath    
}

<#
.SYNOPSIS    
    Reads property from the PowerEnv.config file.

.DESCRIPTION
    If property exists it will return it's value if not null will be returned. If file doesn't exist the null will be returned.

.PARAMETER Property
    Name of the property read.

.EXAMPLE
    Env-Read -Propery age

    Reads value of the property 'age'
#>
function global:Env-Read 
{
    Param
    (
        [Parameter(Mandatory=$true)]
	    [string]$Property
    )
    
    $configPath = ConfigPath
    
    if (Test-Path $configPath)
    {
        $settigns = Import-Clixml -Path $configPath

        return $settigns[$Property]
    }
    else
    {
        return
    }
}
