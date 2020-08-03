<#
.Synopsis
   Gets a collection CloudFoundry Organization objects
.DESCRIPTION
   The Get-Organizations cmdlet gets Organization objects from the CloudFoundry API
.EXAMPLE
   Get-CFToken -API "https://api.cf.my.domain.com" -Username "myusername" -Password "mypassword" | Set-Headers
   Get-Organizations | ConvertTo-Json
#>
function Get-Organizations {

    [CmdletBinding()]
    [OutputType([psobject])]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        Write-Output (Invoke-PagedGetRequest "/v3/organizations")
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}