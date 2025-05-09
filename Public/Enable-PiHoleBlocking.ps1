function Enable-PiHoleBlocking {
    <#
    .SYNOPSIS
    Enables DNS blocking in Pi-hole.

    .DESCRIPTION
    This function authenticates to the Pi-hole API using Connect-PiHole, enables DNS blocking, and then disconnects the session using Disconnect-PiHole.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER Timer
    Optional. Number of seconds until blocking mode is automatically changed back.

    .EXAMPLE
    $cred = Get-Credential
    Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $cred

    .EXAMPLE
    Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $cred -Timer 300
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false)]
        [int]$Timer
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

            # Prepare API request to enable blocking
            $url = "$BaseUrl/api/dns/blocking"
            $headers = @{
                'X-FTL-SID' = $sessionData.SID
                'Content-Type' = 'application/json'
            }

            $body = @{
                blocking = $true
                timer = if ($PSBoundParameters.ContainsKey('Timer')) { $Timer } else { $null }
            } | ConvertTo-Json

            $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ErrorAction Stop

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