function Get-PiHoleStats {
    <#
    .SYNOPSIS
    Gets Pi-hole statistics summary.

    .DESCRIPTION
    This function retrieves current statistics from the Pi-hole API using the /stats/summary endpoint.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password and any username. $creds = Get-Credential -UserName admin

    .EXAMPLE
    $creds = Get-Credential -UserName admin
    Get-PiHoleStats -BaseUrl 'http://pi.hole' -Credential $creds
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

            # Prepare API request
            $url = "$BaseUrl/api/stats/summary"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }

            $invokeParams = @{
                Uri         = $url
                Method     = 'Get'
                Headers    = $headers
                ErrorAction = 'Stop'
            }
            $response = Invoke-RestMethod @invokeParams

            return $response
        }
        catch {
            Write-Error "Failed to retrieve Pi-hole stats: $_"
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