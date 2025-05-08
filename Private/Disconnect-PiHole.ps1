function Disconnect-PiHole {
    <#
    .SYNOPSIS
    Ends the current Pi-hole session by its Session ID (SID).

    .DESCRIPTION
    The function sends a DELETE request to the Pi-hole API to delete the session by ID.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., https://pi.hole).

    .PARAMETER Id
    The ID of the session to be deleted.


    .EXAMPLE
    Disconnect-PiHole -BaseUrl "https://pi.hole" -SessionId 3 -Credential (Get-Credential)

    This example deletes the session with the given SID from the specified Pi-hole instance using the provided credentials.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [string]$SID
    )

    $url = "$BaseUrl/api/auth/session/$Id"

    # Create headers
    $headers = @{
        'X-FTL-SID' = $SID
    }

    try {
        Invoke-RestMethod -Uri $url -Method Delete -Headers $headers -ErrorAction Stop
    } catch {
        Write-Host "Failed to delete session: $_" -ForegroundColor Red
    }
}
