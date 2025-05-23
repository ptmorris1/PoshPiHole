function Get-PiHoleClientHistory {
    <#
    .SYNOPSIS
    Retrieves per-client activity graph data from the Pi-hole API.

    .DESCRIPTION
    This function authenticates to the Pi-hole API using Connect-PiHole, retrieves per-client activity graph data for the last 24 hours, and then disconnects the session using Disconnect-PiHole.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER ClientsReturned
    The maximum number of clients to return. Setting this to 0 will return all clients. Default is 0.

    .OUTPUTS
    The client history data returned by the Pi-hole API.

    .EXAMPLE
    $cred = Get-Credential
    Get-PiHoleClientHistory -BaseUrl 'http://pi.hole' -Credential $cred -ClientsReturned 10
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^http://')]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter()]
        [int]$ClientsReturned = 0
    )

    begin {
        # Nothing to validate in the begin block
    }

    process {
        try {
            # Authenticate and get session data
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

            # Prepare API request to get client history
            $url = "$BaseUrl/api/history/clients?N=$ClientsReturned"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }

            Write-Verbose "Request URL: $url"
            Write-Verbose "Request Headers: $($headers | Out-String)"

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
