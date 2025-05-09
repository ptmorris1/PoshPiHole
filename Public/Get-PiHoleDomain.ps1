function Get-PiHoleDomain {
    <#
    .SYNOPSIS
    Retrieves the domains from the Pi-hole API.

    .DESCRIPTION
    This function authenticates to the Pi-hole API using Connect-PiHole, retrieves the domains, and then disconnects the session using Disconnect-PiHole.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .OUTPUTS
    A PSCustomObject containing the domains data.

    .EXAMPLE
    $cred = Get-Credential
    Get-PiHoleDomain -BaseUrl 'http://pi.hole' -Credential $cred
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        # Validate BaseUrl uses http
        if (-not $BaseUrl.StartsWith('http://')) {
            throw "Error: BaseUrl must use the 'http' scheme."
        }
    }

    process {
        try {
            # Authenticate and get session data
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

            # Prepare API request to get domains
            $url = "$BaseUrl/api/domains"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }

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