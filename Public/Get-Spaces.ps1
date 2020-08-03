<#
.Synopsis
   Gets a collection CloudFoundry Space objects
.DESCRIPTION
   The Get-Spaces cmdlet gets Space objects from the CloudFoundry API for a particular organization
.PARAMETER Org
   The name of an organization to retrieve spaces for
.EXAMPLE
   Get-CFToken -API "https://api.cf.my.domain.com" -Username "myusername" -Password "mypassword" | Set-Headers
   Get-Spaces -Org foo | ConvertTo-Json
#>
function Get-Spaces {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]        
        [psobject]
        $Org
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        Write-Output (Invoke-PagedGetRequest "/v3/spaces?organization_guids=$($Org.guid)")
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}