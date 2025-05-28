function Get-PiHoleHost {
    <#
    .SYNOPSIS
    Retrieves host information from the Pi-hole API.

    .DESCRIPTION
    Authenticates to the Pi-hole API and retrieves host information using the /info/host endpoint.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .OUTPUTS
    The host information returned by the Pi-hole API.

    .EXAMPLE
    Get-PiHoleHost -BaseUrl 'http://pi.hole' -Credential $cred
    #>
    [CmdletBinding()]
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
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential
            $url = "$($BaseUrl)/api/info/host"
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
