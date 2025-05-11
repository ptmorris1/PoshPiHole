function Get-PiHoleSystemInfo {
    <#
    .SYNOPSIS
    Gets Pi-hole system information (uptime, memory, CPU, etc).

    .DESCRIPTION
    This function retrieves system info from the Pi-hole API /api/info/system endpoint and returns a detailed PSCustomObject.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password and any username. $creds = Get-Credential -UserName admin

    .EXAMPLE
    $creds = Get-Credential -UserName admin
    Get-PiHoleSystemInfo -BaseUrl 'http://pi.hole' -Credential $creds
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        if (-not $BaseUrl.StartsWith('http://')) {
            throw "Error: BaseUrl must use the 'http' scheme."
        }
    }

    process {
        try {
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential
            $url = "$BaseUrl/api/info/system"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID }
            $invokeParams = @{
                Uri         = $url
                Method      = 'Get'
                Headers     = $headers
                ErrorAction = 'Stop'
            }
            $response = Invoke-RestMethod @invokeParams
            if ($response) {
                return $response
            } else {
                Write-Error "No system info returned from Pi-hole."
            }
        } catch {
            Write-Error "Failed to retrieve Pi-hole system info: $_"
            if ($sessionData) {
                Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
            }
        } finally {
            if ($sessionData) {
                Disconnect-PiHole -BaseUrl $BaseUrl -Id $sessionData.ID -SID $sessionData.SID
            }
        }
    }

    end {}
}
