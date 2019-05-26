<#
.Synopsis
   Convert rate table data into a HTML string.
.PARAMETER Title
   The title of the HTML page
.PARAMETER Header
   Header to use for HMTL page. Defaults to HTML style supplied with module.
.PARAMETER InputObject
    List of rates to be converted to HTML
.PARAMETER ShowExVAT
   Switch to show exVAT prices instead of incVAT prices
.PARAMETER TargetRate
   Target rate to highlight
.PARAMETER Highlight
   The values that should be highlighted. I.e. Lower, Higher or Equal to the TargetRate
.PARAMETER HighlightColour
   The HTML colour code to be used for highlighting. Default is green.
.INPUTS
   List of the standard unit rates to convert to HTML
.OUTPUTS
   Returns a string of html
.EXAMPLE
   $agileRates = Get-OctopusEnergyHelperEnergyProductTariff -tariff_code "E-1R-AGILE-18-02-21-A" -period_from (Get-Date) -Verbose
   ($agileRates).'standard-unit-rates' | ConvertTo-OctopusEnergyHelperRateHTML -TargetRate 11 -Highlight Lower | Out-File .\AgileRate.html
.FUNCTIONALITY
   Converts a list of rates into a HTML which can be viewed in a web browser. Default to showing VAT inclusive prices, converting the dates and times to the timezone of the local system.
#>

function ConvertTo-OctopusEnergyHelperRateHTML
{
   [CmdletBinding()]
   Param(

    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [Object[]]$InputObject,

    [string]$Title = "Octopus Energy HTML Rate Table",

    [string]$Header = ((Get-Content "$($MyInvocation.MyCommand.Module.ModuleBase)\Private\Files\HeaderHTML.txt")-join ""),

    [switch]$ShowExVAT,

    [float]$TargetRate,

    [ValidateSet("Higher","Equal","Lower")]
    [string]$Highlight="Equal",

    [ValidatePattern("^#[A-Z0-9]{6}$")]
    [string]$HighlightColour = "#DAF7A6"
   )

   Begin
   {
        $list = [System.Collections.Generic.List[PSObject]]::new()
   }
   Process
   {
        $list.Add($InputObject)
   }
   End
   {
      if($ShowExVAT)
      {
         $vatProperty = "value_inc_vat"
      }
      else
      {
         $vatProperty = "value_exc_vat"
      }

      $firstItem = $list | Select-Object -First 1
      $preContent = "Octopus Energy HTML Rate Table Generated on $(Get-Date -format f)"
      $columns = ($firstItem | Get-Member -MemberType NoteProperty).Name | Where-Object {$_ -ne $vatProperty}
      $columnHash = [ordered]@{}
      $TextInfo = (Get-Culture).TextInfo

      Foreach($column in $columns)
      {
         $columnTitle = $column -replace "_" , " "
         $columnTitle = $TextInfo.ToTitleCase($columnTitle)
         $columnHash.Add($column,$columnTitle)
      }

      $rows = @()
      foreach($item in $list)
      {
         $row = [PSCustomObject]@{"Target" = "-"}

         foreach($column in $columnHash.GetEnumerator())
         {
               $property = $item | Select-Object -ExpandProperty $column.key
               $float = [string]$property -as [float]

               If(!$float){$value = $property | Get-Date -format "f"}
               else
               {
               $value = $float
               If($TargetRate)
               {
                  If([float]$float -gt $TargetRate)
                  {
                     $row.Target = "^ $TargetRate"
                  }
                  ElseIf([float]$float -lt $TargetRate)
                  {
                     $row.Target = "v $TargetRate"
                  }
                  ElseIf([float]$float -eq $TargetRate)
                  {
                     $row.Target = "= $TargetRate"
                  }
               }
               }
               $row | Add-Member -MemberType NoteProperty -Name $column.value -Value $value
         }
         $rows += $row
      }

      $html = $rows | ConvertTo-Html -Title $Title -PreContent "$Header$preContent"

      $backGroundColour = "background-color:$HighlightColour"

      If($Highlight)
      {
         Switch($Highlight)
         {
            "Higher"{$replaceChar = "^ $TargetRate"}
            "Equal"{$replaceChar = "= $TargetRate"}
            "Lower"{$replaceChar = "v $TargetRate"}
         }
         $html= $html -replace "<tr><td>$replaceChar","<tr style=$backGroundColour><td align=right>$replaceChar"
      }

      Return $html
   }
}
