
<#
.Synopsis
    Converts a hashtable of parameters to the format expected by the Octopus Energy API
.EXAMPLE
    $hashtable | ConvertTo-OctopusEnergyHelperAPIParam
.INPUTS
    InputObject - Hashtable containing the values to pass to the Octopus Energy API
.FUNCTIONALITY
    Converts a hashtable of parameters to the format expected by the Octopus Energy API
#>
function ConvertTo-OctopusEnergyHelperAPIParam
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True)]
        [hashtable] $InputObject
    )

    $outputHashTable =@{}
    foreach ($var in $InputObject.GetEnumerator())
    {
        if($var.value -or $var.value -eq 0)
        {
            switch($var.value.GetType().Name)
            {
                'DateTime'{ #Dates need to be converted to ISO 8601 format
                    $value = $var.value | Get-Date -Format "o"
                }
                default {
                    $value = $var.value
                }
            }

            switch($var.name)
            {
                default {
                    $outputHashTable.Add($var.name,$value)
                }
            }
            Write-Verbose "[$($var.name)] [$($var.value.GetType().Name)] will be added with value [$value]"
        }
    }
    Return $outputHashTable
}