function Disable-PiHoleBlocking {
    <#
    .SYNOPSIS
    Disables Pi-hole blocking with an optional timer.

    .DESCRIPTION
    This function sends a POST request to the Pi-hole API to disable blocking. If a timer value of 0 is provided, it sets the timer to null; otherwise, it uses the supplied integer value.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER Timer
    An optional integer value for the timer in seconds. Use 0 to set the timer to null.

    .EXAMPLE
    $cred = Get-Credential
    Disable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $cred -Timer 15
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false)]
        [int]$Timer = 0
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

            # Prepare API request to set blocking status
            $url = "$BaseUrl/api/dns/blocking"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }

            $body = @{
                blocking = $false
                timer    = if ($Timer -eq 0) { $null } else { $Timer }
            } | ConvertTo-Json -Depth 1

            $invokeParams = @{
                Uri         = $url
                Method      = 'Post'
                Headers     = $headers
                Body        = $body
                ContentType = 'application/json'
                ErrorAction = 'Stop'
            }
            $response = Invoke-RestMethod @invokeParams

            Write-Host "Blocking disabled successfully." -ForegroundColor Green
            return $response
        } catch {
            Write-Host "Error: $_" -ForegroundColor Red
            Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.SID -SID $sessionData.SID
        } finally {
            if ($sessionData) {
                Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
            }
        }
    }

    end {
        # Nothing to clean up in the end block
    }
}