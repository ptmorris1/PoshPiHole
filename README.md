# PoshPiHole

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PoshPiHole.svg)](https://www.powershellgallery.com/packages/PoshPiHole)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()

PowerShell module to interact with the [Pi-hole v6 API](https://docs.pi-hole.net/api/)

---

## 📖 Table of Contents

- [PoshPiHole](#poshpihole)
  - [📖 Table of Contents](#-table-of-contents)
  - [🦾 Description](#-description)
  - [🛠 Requirements](#-requirements)
  - [📦 Installation](#-installation)
  - [🔐 Authentication](#-authentication)
  - [📚 Available Functions](#-available-functions)
    - [🔻 Disable-PiHoleBlocking](#-disable-piholeblocking)
    - [🔼 Enable-PiHoleBlocking](#-enable-piholeblocking)
    - [📶 Get-PiHoleBlocking](#-get-piholeblocking)
    - [🦾 Get-PiHoleHistory](#-get-piholehistory)
    - [🗂 Get-PiHoleSummary](#-get-piholesummary)
    - [📊 Get-PiHoleStats](#-get-piholestats)
    - [🌐 Get-PiHoleDomain](#-get-piholedomain)
    - [🖥 Get-PiHoleSystemInfo](#-get-piholesysteminfo)
    - [🧩 Get-PiHoleVersion](#-get-piholeversion)
  - [📣 Contributions \& Issues](#-contributions--issues)
  - [📄 License](#-license)
  - [📅 Changelog](#-changelog)

---

## 🦾 Description

**PoshPiHole** is a PowerShell module that enables you to interact with your Pi-hole server programmatically.
It provides functions to:

* Manage DNS blocking
* Retrieve real-time and historical statistics
* Query domain history
* Access database summaries
* And more!

---

## 🛠 Requirements

* PowerShell 7 or higher
* Pi-hole v6+
* HTTP access to your Pi-hole server

  > ⚠️ HTTPS is **not supported**

---

## 📦 Installation

Install from the PowerShell Gallery:

```powershell
Install-Module -Name PoshPiHole -Scope CurrentUser
```

---

## 🔐 Authentication

All functions require a `PSCredential` object.
The **username can be anything**, but the password must match your Pi-hole password.

```powershell
$creds = Get-Credential -UserName admin
```

---

## 📚 Available Functions

### 🔻 Disable-PiHoleBlocking

Temporarily or permanently disables DNS blocking on your Pi-hole.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance (e.g., `http://pi.hole`)
* `Credential` – PSCredential object
* `Timer` – (Optional) Duration to disable blocking (in seconds)

```powershell
# Disabled blocking for 15 seconds
Disable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds -Timer 15

# Disables blocking until re-enabled again.
Disable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🔼 Enable-PiHoleBlocking

Re-enables DNS blocking on your Pi-hole.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 📶 Get-PiHoleBlocking

Retrieves current blocking status and related metadata.

**Returns:**
A `PSCustomObject` with:

* `BlockingStatus`
* `Timer`
* `ProcessingTime`

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

---

### 🦾 Get-PiHoleHistory

Fetches DNS query history including timestamps and types.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleHistory -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🗂 Get-PiHoleSummary

Retrieves a summary of DNS queries from the database within a specified time range.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object
* `From` – Start time/date (any format accepted by `Get-Date`)
* `Until` – End time/date

```powershell
# Summary for last 24 hours
Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds `
  -From (Get-Date).AddDays(-1) -Until (Get-Date)

# Summary for specific date range
Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds `
  -From '2025-01-01' -Until '2025-01-03'
```

---

### 📊 Get-PiHoleStats

Retrieves current usage and performance statistics.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleStats -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🌐 Get-PiHoleDomain

Fetches domain lists from the Pi-hole database.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleDomain -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🖥 Get-PiHoleSystemInfo

Retrieves detailed system information from the Pi-hole server, including uptime, memory, CPU, and process statistics.

**Returns:**
A `PSCustomObject` with the following structure:

- `system` (object)
  - `uptime` (integer): System uptime in seconds
  - `memory` (object)
    - `ram` (object)
      - `total`, `free`, `used`, `available` (integer): RAM stats in KB
      - `%used` (number): Used RAM in percent
    - `swap` (object)
      - `total`, `used`, `free` (integer): Swap stats in KB
      - `%used` (number): Used swap in percent
  - `procs` (integer): Number of processes
  - `cpu` (object)
    - `nprocs` (integer): Number of processors
    - `%cpu` (number): Total CPU usage in percent
    - `load` (object)
      - `raw` (array): 1, 5, 15 minute load averages (raw)
      - `percent` (array): 1, 5, 15 minute load averages (percent)
- `took` (number): Time in seconds to process the request

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance (e.g., `http://pi.hole`)
* `Credential` – PSCredential object

```powershell
$creds = Get-Credential -UserName admin
Get-PiHoleSystemInfo -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🧩 Get-PiHoleVersion

Retrieves version information for the Pi-hole server and its components.

**Returns:**
A `PSCustomObject` with the following structure:

- `core` (string): Pi-hole core version
- `web` (string): Web interface version
- `ftl` (string): FTL engine version
- `api` (string): API version
- `took` (number): Time in seconds to process the request

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance (e.g., `http://pi.hole`)
* `Credential` – PSCredential object

```powershell
$creds = Get-Credential -UserName admin
Get-PiHoleVersion -BaseUrl 'http://pi.hole' -Credential $creds
```

---

## 📣 Contributions & Issues

Feel free to open issues, submit pull requests, or suggest features!

---

## 📄 License

This project is licensed under the MIT License.

---

## 📅 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a history of changes and release notes.

---
