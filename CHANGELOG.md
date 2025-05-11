# 📅 Changelog

All notable changes to the **PoshPiHole** module will be documented in this file.

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
