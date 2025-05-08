function Enable-PiHoleBlocking {
    <#
    .SYNOPSIS
    Enables Pi-hole blocking.

    .DESCRIPTION
    This function sends a POST request to the Pi-hole API to enable blocking.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password and any username.  $creds = Get-Credential -UserName admin

    .EXAMPLE
    $creds = Get-Credential -UserName admin
    Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds
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

            # Prepare API request to set blocking status
            $url = "$BaseUrl/api/dns/blocking"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }

            $body = @{
                blocking = $true
            } | ConvertTo-Json -Depth 1

            $invokeParams = @{
                Uri         = $url
                Method      = 'Post'
                Headers     = $headers
                Body       = $body
                ContentType = 'application/json'
                ErrorAction = 'Stop'
            }
            $response = Invoke-RestMethod @invokeParams

            Write-Host "Blocking enabled successfully." -ForegroundColor Green
            return $response
        }
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
            Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.SID -SID $sessionData.SID
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