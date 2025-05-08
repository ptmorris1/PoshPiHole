function Get-PiHoleSummary {
    <#
    .SYNOPSIS
    Gets Pi-hole database content summary.

    .DESCRIPTION
    This function retrieves various database content details from the Pi-hole API.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password and any username. $creds = Get-Credential -UserName admin

    .PARAMETER From
    Start date/time. Accepts any format that Get-Date supports.

    .PARAMETER Until
    End date/time. Accepts any format that Get-Date supports.

    .EXAMPLE
    $creds = Get-Credential -UserName admin
    Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds -From "2023-01-01" -Until "2023-01-02"

    .EXAMPLE
    Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds -From (Get-Date).AddDays(-1) -Until (Get-Date)
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $true)]
        $From,

        [Parameter(Mandatory = $true)]
        $Until
    )

    begin {
        # Validate BaseUrl uses http
        if (-not $BaseUrl.StartsWith('http://')) {
            throw "Error: BaseUrl must use the 'http' scheme."
        }

        # Convert dates to Unix timestamps
        try {
            $fromDate = Get-Date $From
            $untilDate = Get-Date $Until
            $fromUnix = [int64](Get-Date $fromDate -UFormat %s)
            $untilUnix = [int64](Get-Date $untilDate -UFormat %s)
        }
        catch {
            throw "Error converting dates to Unix timestamp: $_"
        }
    }

    process {
        try {
            # Authenticate and get session data
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

            # Prepare API request
            $url = "$BaseUrl/api/stats/database/summary?from=$fromUnix&until=$untilUnix"
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
            Write-Error "Failed to retrieve Pi-hole summary: $_"
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