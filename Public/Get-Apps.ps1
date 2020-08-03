<#
.Synopsis
   Gets a collection CloudFoundry App objects
.DESCRIPTION
   The Get-Apps cmdlet gets App objects from the CloudFoundry API
.PARAMETER Spaces
   Limits the request to a list of (or single) space
.EXAMPLE
   Get-CFToken -API "https://api.cf.my.domain.com" -Username "myusername" -Password "mypassword" | Set-Headers
   Get-Organizations | where {$_.Name -eq 'my-org'} | Get-Spaces | where {$_.Name -eq "my-space"} | Get-Apps | ConvertTo-Json
#>
function Get-Apps {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]        
        [psobject]
        $Spaces,

        [Parameter()]
        [ValidateSet("v2","v3")]
        [string]
        $APIVersion="v3"
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        $query_preamble="space_guids="
        if("v2" -eq $APIVersion) {
            $query_preamble="q=space_guid%20IN%20"
        }
        foreach($space in $Spaces) {
            Write-Output (Invoke-PagedGetRequest "/$APIVersion/apps?$query_preamble$($space.guid)")
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}