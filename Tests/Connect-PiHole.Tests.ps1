Describe 'Connect-PiHole' -Tag 'Integration' {

    BeforeAll {
        $baseUrl   = $env:PIHOLE_URL
        $plainPass = $env:PIHOLE_PASSWORD

        if (-not $baseUrl -or -not $plainPass) {
            Write-Warning 'Skipping tests: Required environment variables PIHOLE_URL or PIHOLE_PASSWORD not set.'
            Skip 'Missing required test environment configuration.'
        }

        $credential = New-Object System.Management.Automation.PSCredential (
            'admin', (ConvertTo-SecureString $plainPass -AsPlainText -Force)
        )
    }

    It 'Returns a session object with expected properties' {
        $session = Connect-PiHole -BaseUrl $baseUrl -Credential $credential

        $session | Should -Not -BeNullOrEmpty
        $session | Should -BeOfType 'pscustomobject'

        $session.PSObject.Properties.Name | Should -Contain 'SessionId'
        $session.PSObject.Properties.Name | Should -Contain 'CsrfToken'
        $session.PSObject.Properties.Name | Should -Contain 'ExpiresAt'

        $session.SessionId | Should -Not -BeNullOrEmpty
        $session.ExpiresAt | Should -BeGreaterThan ([DateTime]::UtcNow)
    }

    It 'Throws on invalid credentials' {
        $badCred = New-Object System.Management.Automation.PSCredential (
            'admin', (ConvertTo-SecureString 'invalid-password' -AsPlainText -Force)
        )

        { Connect-PiHole -BaseUrl $baseUrl -Credential $badCred } | Should -Throw
    }
}