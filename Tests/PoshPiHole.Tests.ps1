BeforeAll {
    # Import the module
    Import-Module -Name "$PSScriptRoot\..\PoshPiHole.psd1" -Force
    
    # Get credentials from environment or prompt
    if ($env:PIHOLE_PASSWORD) {
        $securePassword = ConvertTo-SecureString $env:PIHOLE_PASSWORD -AsPlainText -Force
        $script:credential = New-Object System.Management.Automation.PSCredential ("username", $securePassword)
    } else {
        $script:credential = Get-Credential -Message "Enter Pi-hole password" -UserName "username"
    }
    
    # Set base URL from environment or default
    $script:baseUrl = if ($env:PIHOLE_URL) { $env:PIHOLE_URL } else { "http://pi.hole" }
}

Describe "Connect-PiHole" {
    It "Should throw when BaseUrl does not start with http://" {
        { Connect-PiHole -BaseUrl "https://pi.hole" -Credential $credential } | 
        Should -Throw "Error: BaseUrl must use the 'http' scheme."
    }

    It "Should successfully connect and return session data" {
        $result = Connect-PiHole -BaseUrl $baseUrl -Credential $credential
        $result.SID | Should -Not -BeNullOrEmpty
        $result.ID | Should -Not -BeNullOrEmpty
        $result.CSRF | Should -Not -BeNullOrEmpty
        $result.Validity | Should -BeGreaterThan 0
    }
}

Describe "Get-PiHoleBlocking" {
    It "Should throw when BaseUrl does not start with http://" {
        { Get-PiHoleBlockingStatus -BaseUrl "https://pi.hole" -Credential $credential } | 
        Should -Throw "Error: BaseUrl must use the 'http' scheme."
    }

    It "Should return blocking status" {
        $result = Get-PiHoleBlockingStatus -BaseUrl $baseUrl -Credential $credential
        $result.BlockingStatus | Should -BeIn @($true, $false)
        $result.Timer | Should -Not -BeNullOrEmpty
        $result.Took | Should -BeGreaterThan 0
    }
}

Describe "Set-PiHoleBlocking" {
    It "Should throw when BaseUrl does not start with http://" {
        { Set-PiHoleBlocking -BaseUrl "https://pi.hole" -Credential $credential -EnableBlocking } | 
        Should -Throw "Error: BaseUrl must use the 'http' scheme."
    }

    It "Should successfully enable blocking" {
        $result = Set-PiHoleBlocking -BaseUrl $baseUrl -Credential $credential -EnableBlocking
        $result.blocking | Should -Be $true
    }

    It "Should successfully disable blocking" {
        $result = Set-PiHoleBlocking -BaseUrl $baseUrl -Credential $credential
        $result.blocking | Should -Be $false
    }

    It "Should set timer when specified" {
        $result = Set-PiHoleBlocking -BaseUrl $baseUrl -Credential $credential -EnableBlocking -Timer 30
        $result.timer | Should -Be 30
    }
}