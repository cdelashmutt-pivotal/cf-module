<#
.Synopsis
   This cmdlet gets a cloudfoundry token
.DESCRIPTION
   Logs into CloudFoundry, sets the script level variables for the header and returns it
.PARAMETER Username
    This parameter is used to identify the username to authenticate
.PARAMETER Password
    This parameter is used to identify the username's password to authenticate
.PARAMETER API
    This parameter is the URL for the Cloud Foundry API endpoint to use.  Something like https://api.cf.some.domain.com.
.EXAMPLE
   Get-Token "https://api.cf.my.domain.com" "bjones" | Set-Headers

   or the insecure way that stores your password in you command history for anyone to find/see:
   Get-Token "https://api.cf.my.domain.com" "bjones" $("P@ssword1" | ConvertTo-SecureString -AsPlainText -Force) | Set-Headers
#>
function Get-CFToken {

    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter( Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $API,

        [Parameter( Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Username,

        [Parameter( Position = 2, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $Password
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12    
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"

        # obtain an access token
        Write-Verbose "Logging into into $($API)"
        Set-Variable -Name baseHost -Scope Script -Value $API
        $url = "$($API)/v2/info"
        Write-Debug $url
        $header = @{
            "Authorization"="Basic Y2Y6"
            "Accept"="application/json"
            "Content-Type"="application/x-www-form-urlencoded; charset=UTF-8"
        }
        $response = Invoke-Retry -ScriptBlock {
            Write-Output (Invoke-WebRequest -Uri $url -Method Get -Header $header)
        }       
        if ($response.StatusCode -ne 200) {
            $message = "$($url) $($response.StatusCode)"
            Write-Error $message
            throw $message
        }
        $url = ($response.Content | ConvertFrom-Json).authorization_endpoint + "/oauth/token"
        Set-Variable -Name oAuthTokenEndpoint -Scope Script -Value $url
        $body = "grant_type=password&password=$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)&scope=&username=$($Username)"
        $response = Invoke-Retry -ScriptBlock {
            Write-Output (Invoke-WebRequest -Uri $url -Method Post -Header $header -Body $body)
        }        
        if ($response.StatusCode -ne 200) {
            $message = "Get-Credentials: $($url) $($response.StatusCode)"
            Write-Error -Message $message
            throw $message
        }                    
        Write-Output $response.Content | ConvertFrom-Json
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}