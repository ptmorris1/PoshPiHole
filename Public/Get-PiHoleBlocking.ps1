function Get-PiHoleBlocking {
    <#
    .SYNOPSIS
    Retrieves the current blocking status from the Pi-hole API.

    .DESCRIPTION
    This function authenticates to the Pi-hole API using Connect-PiHole, retrieves the blocking status, and then disconnects the session using Disconnect-PiHole.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .OUTPUTS
    A PSCustomObject containing the blocking status, timer, and processing time.

    .EXAMPLE
    $cred = Get-Credential
    Get-PiHoleBlockingStatus -BaseUrl 'http://pi.hole' -Credential $cred
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    # Validate BaseUrl uses http
    if (-not $BaseUrl.StartsWith('http://')) {
        throw "Error: BaseUrl must use the 'http' scheme."
    }

    try {
        # Authenticate and get session data
        $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

        # Prepare API request to get blocking status
        $url = "$BaseUrl/api/dns/blocking"
        $headers = @{ 'X-FTL-SID' = $sessionData.SID }

        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop

        # Process and return the response
        $blockingStatus = [PSCustomObject]@{
            BlockingStatus = $response.blocking
            Timer          = $response.timer
            Took           = $response.took
        }

        return $blockingStatus
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
    } finally {
        # Only try to disconnect if we have session data
        if ($sessionData) {
            Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
        }
    }
}