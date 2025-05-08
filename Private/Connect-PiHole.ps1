function Connect-PiHole {
    <#
    .SYNOPSIS
    Authenticates to the Pi-hole v6 API.

    .DESCRIPTION
    Authenticates using a PSCredential object, stores the SID and CSRF token in a variable, and
    reports when the session expires based on the server-provided validity.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole). HTTP only

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password and any username as it is not needed.

    .OUTPUTS
    A PSCustomObject with SID, CSRF token, validity (seconds), and local expiration time.

    .EXAMPLE
    $cred = Get-Credential admin
    Connect-PiHole -BaseUrl 'http://pi.hole' -Credential $cred
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$BaseUrl,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    $plainPassword = $Credential.GetNetworkCredential().Password
    $body = @{ password = $plainPassword } | ConvertTo-Json -Depth 2

    $params = @{
        Uri             = "$BaseUrl/api/auth"
        Method          = 'POST'
        Body            = $body
        ContentType     = 'application/json'
        UseBasicParsing = $true
        UserAgent       = 'PoshPiHole'
    }

    try {
        $login = Invoke-RestMethod @params

        if ($login.session.valid -eq 'true') {
            $validity  = [int]$login.session.validity
            $expiresAt = (Get-Date).AddSeconds($validity)

            $params = @{
                Uri             = "$BaseUrl/api/auth/sessions"
                Method          = 'GET'
                ContentType     = 'application/json'
                UserAgent       = 'PoshPiHole'
                Headers = @{"X-FTL-SID" = $login.session.sid}
            }

            $response = Invoke-RestMethod @params
            $ID = $response.sessions | Where-Object 'user_agent' -Match 'PoshPiHole'
            $sessionData = @{
                BaseUrl   = $BaseUrl
                SID       = $login.session.sid
                CSRF      = $login.session.csrf
                Validity  = $validity
                ExpiresAt = $expiresAt
                ID = $ID.id
            }

            return [PSCustomObject]$sessionData
        }
        else {
            throw "Authentication failed: Session is invalid."
        }
    }
    catch {
        throw "Failed to authenticate with Pi-hole: $_"
    }
}