function Get-PiHoleList {
    <#
    .SYNOPSIS
    Retrieves a Pi-hole list (block or allow) from the API.

    .DESCRIPTION
    Authenticates to the Pi-hole API, retrieves the specified list or all lists, and returns the data.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER List
    (Optional) The list address or name to retrieve (e.g., https://hosts-file.net/ad_servers.txt). If not specified, all lists are returned.

    .PARAMETER Type
    The type of list: 'block' (default) or 'allow'.

    .OUTPUTS
    The list data returned by the Pi-hole API.

    .EXAMPLE
    $cred = Get-Credential
    Get-PiHoleList -BaseUrl 'http://pi.hole' -Credential $cred -List 'https://hosts-file.net/ad_servers.txt' -Type block
    .EXAMPLE
    Get-PiHoleList -BaseUrl 'http://pi.hole' -Credential $cred
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^http://')]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false)]
        [string]$List,

        [Parameter(Mandatory = $false)]
        [ValidateSet('block', 'allow')]
        [string]$Type = 'block'
    )

    begin {
        # Nothing to validate in the begin block
    }

    process {
        try {
            # Authenticate and get session data
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential

            # Prepare API request to get list(s)
            if ($List) {
                $encodedList = [System.Web.HttpUtility]::UrlEncode($List)
                $url = "$BaseUrl/api/lists/$($encodedList)?type=$($Type)"
            } else {
                $url = "$BaseUrl/api/lists?type=$Type"
            }
            Write-Verbose "Request URL: $url"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID; 'Accept' = 'application/json' }

            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop

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
