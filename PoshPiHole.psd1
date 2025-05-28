@{
    ModuleVersion   = '0.5.0'
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
# 📅 Changelog

All notable changes to the **PoshPiHole** module will be documented in this file.

---

## [0.5.0] - 2025-05-28

### Added

* `Get-PiHoleList` – Retrieves the configured adlists from Pi-hole (`GET /lists`).
* `Search-PiHoleDomain` – Search for domains in Pi-hole's lists (`GET /search/{domain}`).
* `Get-PiHoleHost` – Retrieves host information from Pi-hole (`GET /info/host`).
* `Get-PiHoleTeleporter` – Downloads a Pi-hole Teleporter backup as a .zip file (`GET /teleporter`).

---

## [0.4.0] - 2025-05-23

### Added

* `Get-PiHoleSessions` – Retrieves the current Pi-hole sessions (`GET /auth/sessions`).
* `Get-PiHoleClientHistory` – Retrieves per-client activity graph data (`GET /history/clients`).

---

## [0.3.0] - 2025-05-11

### Added

* `Get-PiHoleSystemInfo` – Retrieves detailed system information from Pi-hole (`GET /info/system`).
* `Get-PiHoleVersion` – Retrieves version information for Pi-hole and its components (`GET /info/version`).

### Fixed

* `Disconnect-PiHole` will now delete multiple IDs as expected.

---

## [0.2.2] - 2025-05-10

### Fixed

* `Disconnect-PiHole` will now delete multiple IDs as expected.

---

## [0.2.1] - 2025-04-30

### Fixed

* Resolved issues with `Enable-PiHoleBlocking` and `Disable-PiHoleBlocking` not properly managing sessions.

---

## [0.2.0] - 2025-04-10

### Added

* `Get-PiHoleStats` – Retrieves current Pi-hole usage and performance statistics (`GET /stats/summary`)
* `Get-PiHoleDomain` – Fetches domain lists from Pi-hole (`GET /domains`)

---

## [0.1.0] - 2025-04-01

### Initial Release

* Base module functionality for interacting with the Pi-hole v6 API.
* Implemented the following functions:

  * `Get-PiHoleBlocking` (`GET /auth/sessions`)
  * `Enable-PiHoleBlocking` (`POST /auth/sessions`)
  * `Disable-PiHoleBlocking` (`POST /auth/sessions`)
  * `Get-PiHoleHistory` (`GET /history`)
  * `Get-PiHoleSummary` (`GET /stats/database/summary`)

---

> 📌 This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) principles.

'@
        }
    }
}
