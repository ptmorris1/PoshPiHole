function Search-PiHoleDomain {
    <#
    .SYNOPSIS
    Search for domains in Pi-hole's lists.

    .DESCRIPTION
    Searches for a domain (or partial domain) in Pi-hole's block/allow lists using the /search/{domain} API endpoint.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER Domain
    (Mandatory) The domain or partial domain to search for.

    .PARAMETER Partial
    (Optional) If specified, enables partial matching. Default is $false.

    .PARAMETER Results
    (Optional) Maximum number of results to return. Default is 20.

    .PARAMETER DebugApi
    (Optional) If specified, adds debug information to the response. Default is $false.

    .OUTPUTS
    The search results returned by the Pi-hole API.

    .EXAMPLE
    Search-PiHoleDomain -BaseUrl 'http://pi.hole' -Credential $cred -Domain 'doubleclick.net'
    .EXAMPLE
    Search-PiHoleDomain -BaseUrl 'http://pi.hole' -Credential $cred -Domain 'ads' -Partial -Results 100
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^http://')]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $true)]
        [string]$Domain,

        [Parameter(Mandatory = $false)]
        [switch]$Partial,

        [Parameter(Mandatory = $false)]
        [int]$Results = 20,

        [Parameter(Mandatory = $false)]
        [switch]$DebugApi
    )

    begin {
        # Nothing to validate in the begin block
    }

    process {
        try {
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential
            $encodedDomain = [System.Web.HttpUtility]::UrlEncode($Domain.ToLower())
            $partialValue = if ($Partial.IsPresent) { $true } else { $false }
            $debugValue = if ($DebugApi.IsPresent) { $true } else { $false }
            $url = "$($BaseUrl)/api/search/$($encodedDomain)?partial=$($partialValue)&N=$($Results)&debug=$($debugValue)"
            Write-Verbose "Request URL: $url"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID; 'Accept' = 'application/json' }
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
            if ($sessionData) {
                Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
            }
        }
        finally {
            if ($sessionData) {
                Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
            }
        }
    }

    end {
        # Nothing to clean up in the end block
    }
}
