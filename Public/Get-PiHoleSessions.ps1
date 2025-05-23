function Get-PiHoleSessions {
    <#
    .SYNOPSIS
    Retrieves the current Pi-hole sessions from the API.

    .DESCRIPTION
    This function authenticates to the Pi-hole API using Connect-PiHole, retrieves the current sessions, and then disconnects the session using Disconnect-PiHole.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .OUTPUTS
    The sessions data returned by the Pi-hole API.

    .EXAMPLE
    $cred = Get-Credential
    Get-PiHoleSessions -BaseUrl 'http://pi.hole' -Credential $cred
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^http://')]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        # Nothing to validate in the begin block
    }

    process {
        try {
            # Authenticate and get session data
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

            # Prepare API request to get sessions
            $url = "$BaseUrl/api/auth/sessions"
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
