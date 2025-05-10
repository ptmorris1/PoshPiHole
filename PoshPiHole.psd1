@{
    ModuleVersion   = '0.2.2'
    Guid            = '9fb0c9cf-ea85-4633-8915-c6d8a9379ab7'
    CompanyName     = 'Patrick Morris'
    Copyright       = '2025 Patrick Morris'
    Author          = 'Patrick Morris'
    AliasesToExport = '*'
    RootModule      = 'PoshPiHole.psm1'
    Description     = 'PowerShell module for interacting with the Pi-hole v6 API'
    PrivateData     = @{
        PSData = @{
            Tags         = 'Windows', 'PiHole', 'PowerShell', 'PSEdition_Core', 'Pi-Hole', 'API'
            ProjectURI   = 'https://github.com/ptmorris1/PoshPiHole'
            LicenseURI   = 'https://github.com/ptmorris1/PoshPiHole/blob/main/LICENSE'
            ReleaseNotes = @'
### PoshPiHole 0.1.0
* Initial Release of PoshPiHole
  * PowerShell module for interacting with the Pi-hole v6 API!
   * Get-PiHoleBlocking       get /auth/sessions
   * Enable-PiHoleBlocking    post /auth/sessions
   * Disable-PiHoleBlocking   post /auth/sessions
   * Get-PiHoleHistory        get /history
   * Get-PiHoleSummary        get /stats/database/summary
---
### PoshPiHole 0.2.0
  * Get-PiHoleDomain          get /domains
  * Get-PiHoleStats           get /stats/summary
---
### PoshPiHole 0.2.1
  * Fixed Enable and Disable-PiHoleBlocking
---
### PoshPiHole 0.2.2
  * Disable-PiHoleBlocking will now delete multiple ID
---
'@
        }
    }
}