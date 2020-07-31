<#
.Synopsis
   Gets a collection CloudFoundry App objects
.DESCRIPTION
   The Get-Apps cmdlet gets App objects from the CloudFoundry API
.PARAMETER Space
    Optional space to restrict apps retrieved from
.PARAMETER Name
    This parameter is the name of the space
.EXAMPLE
   Get-CFToken -API "https://api.cf.my.domain.com" -Username "myusername" -Password "mypassword" | Set-Headers
   Get-Apps | ConvertTo-Json
#>
function Get-Apps {

    [CmdletBinding()]
    [OutputType([psobject])]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        Write-Output (Invoke-PagedGetRequest "/v3/apps")
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}