function Disconnect-PiHole {
    <#
    .SYNOPSIS
    Ends the current Pi-hole session by its ID or IDs.

    .DESCRIPTION
    The function sends a DELETE request to the Pi-hole API to delete the session(s) by ID.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., https://pi.hole).

    .PARAMETER Id
    The ID or array of IDs of the session(s) to be deleted.

    .PARAMETER SID
    The Session ID token required for authentication.

    .EXAMPLE
    Disconnect-PiHole -BaseUrl "https://pi.hole" -Id 3 -SID "abc123xyz"

    This example deletes the session with ID 3 from the specified Pi-hole instance using the provided session ID.

    .EXAMPLE
    Disconnect-PiHole -BaseUrl "https://pi.hole" -Id 3,4,5 -SID "abc123xyz"

    This example deletes sessions with IDs 3, 4, and 5 from the specified Pi-hole instance using the provided session ID.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [string[]]$Id,

        [Parameter(Mandatory = $true)]
        [string]$SID
    )

    foreach ($i in $Id) {
        $url = "$BaseUrl/api/auth/session/$i"
        $headers = @{
            'X-FTL-SID' = $SID
        }
        try {
            Invoke-RestMethod -Uri $url -Method Delete -Headers $headers -ErrorAction Stop
        } catch {
            Write-Host "Failed to delete session $i - $_" -ForegroundColor Red
        }
    }
}
