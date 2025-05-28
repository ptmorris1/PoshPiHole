function Get-PiHoleTeleporter {
    <#
    .SYNOPSIS
    Downloads a Pi-hole Teleporter backup as a .zip file.

    .DESCRIPTION
    Authenticates to the Pi-hole API and downloads the Teleporter backup (.zip) using the /teleporter endpoint.

    .PARAMETER BaseUrl
    The base URL of the Pi-hole instance (e.g., http://pi.hole).

    .PARAMETER Credential
    A PSCredential object containing the Pi-hole password.

    .PARAMETER OutputPath
    The path where the downloaded .zip file will be saved.

    .OUTPUTS
    The path to the downloaded .zip file.

    .EXAMPLE
    Get-PiHoleTeleporter -BaseUrl 'http://pi.hole' -Credential $cred -OutputPath 'C:\backup\teleporter.zip'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^http://')]
        [string]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if ($_ -notmatch '\.zip$') {
                throw 'OutputPath must have a .zip file extension.'
            }
            return $true
        })]
        [string]$OutputPath
    )

    begin {
        # Nothing to validate in the begin block
    }

    process {
        try {
            $sessionData = Connect-PiHole -BaseUrl $BaseUrl -Credential $Credential
            $url = "$($BaseUrl)/api/teleporter"
            Write-Verbose "Request URL: $url"
            $headers = @{ 'X-FTL-SID' = $sessionData.SID; 'Accept' = 'application/zip' }
            Invoke-WebRequest -Uri $url -Method Get -Headers $headers -OutFile $OutputPath -ErrorAction Stop
            #Write-Host "Teleporter backup downloaded to: $OutputPath" -ForegroundColor Green
            return $OutputPath
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
