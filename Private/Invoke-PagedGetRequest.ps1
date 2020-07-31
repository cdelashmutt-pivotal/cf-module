<#
.Synopsis
   Calls a Rest Get Web Request
.DESCRIPTION
   The Invoke-GetRequest cmdlet makes a get Rest call
.PARAMETER Path
    The url path to call (should not include the basehost address)
#>
function Invoke-PagedGetRequest {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter( Position = 0, Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        $resources = @()
        $response = Invoke-GetRequest $Path
        $resources += $response.resources

        while ($response.pagination.next.href -match "https://[^/]*(.*)") {
            $response = Invoke-GetRequest $Matches[1]
            $resources += $response.resources
        }
        Write-Output $resources
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }    
}