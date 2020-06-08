<#
.SYNOPSIS
    Retrieves the Octopus Energy API parameters
.DESCRIPTION
    Retrieves the Octopus Energy API parameter names from the parameter aliases defined in the function
.PARAMETER InvocationInfo
    InvocationInfo object from the calling function
.PARAMETER HashTable
    Hashtable containing the values to pass to the Octopus Energy API
.PARAMETER Clear
    Array of values which should be sent empty to Octopus Energy API
.PARAMETER Join
    Hashtable containing values which need to be joined by specific separator
.PARAMETER Exclude
    Array of parameter names which should be excluded from the output hashtable
.EXAMPLE
    C:\PS>$MyInvocation | Get-OctopusEnergyHelperAPIParameter -HashTable $hashTable
    Retrieve the Octopus Energy API parameter names from the supplied invocation object
#>
Function Get-OctopusEnergyHelperAPIParameter
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [System.Management.Automation.InvocationInfo]$InvocationInfo,

        [hashtable] $HashTable,

        [string[]] $Clear=@(),

        [hashtable] $Join=@{},

        [string[]] $Exclude=@()
    )

    $parameterAction = $Hashtable
    $parameterAction.Remove("InputHashTable")
    $parameterAction.Remove("InvocationInfo")

    $outputHashtable = @{}

    # Avoiding sending any common parameters
    $Exclude += [System.Management.Automation.PSCmdlet]::CommonParameters
    $Exclude += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
    # AKey is sent as part of the request header
    $Exclude += "APIKey"

    #Remove excluded variables
    $workingHash = $Hashtable.GetEnumerator() | Where-Object {$_.Key -notin $Exclude}

    #Ignore common parameters and find aliases of parameters which need to be renamed
    $FunctionInfo = (Get-Command -Name $InvocationInfo.InvocationName)
    $parameterMetadata = $FunctionInfo.Parameters.Values
    $aliases = $parameterMetadata | Select-Object -Property Name, Aliases | Where-Object {$_.Name -in $workingHash.Key -and $_.Aliases}
    $rename = @{}
    foreach($item in $aliases)
    {   # Rename parameter using first alias
        $rename[$item.name] = $item.aliases[0]
    }

    foreach($cItem in $Clear)
    {
        If($Hashtable.ContainsKey($cItem))
        {
            $Hashtable[$_] = ""
        }
        else
        {
            $outputHashtable[$cItem] = ""
        }
    }

    foreach($item in $workingHash)
    {
        $itemName = $item.Name

        Switch($itemName)
        {
            {$rename.ContainsKey($_)}{
                $outputHashtable[$rename[$_]] = $Hashtable[$_]
            }
            {$Join.ContainsKey($_)}{
                $outputHashtable[$_] = $Hashtable[$_] -join $Join[$_]
            }
            Default {
                $outputHashtable[$_] = $Hashtable[$_]
            }
        }
    }
    Return $outputHashtable
}