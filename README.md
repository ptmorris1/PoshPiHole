# PoshPiHole

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PoshPiHole.svg)](https://www.powershellgallery.com/packages/PoshPiHole)
![Downloads](https://img.shields.io/powershellgallery/dt/PoshPiHole)
![PSGallery Quality](https://img.shields.io/powershellgallery/p/PoshPiHole)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()

PowerShell module to interact with the [Pi-hole v6 API](https://docs.pi-hole.net/api/)

---

## 📖 Table of Contents <!-- omit in toc -->

- [PoshPiHole](#poshpihole)
  - [🦾 Description](#-description)
  - [🛠 Requirements](#-requirements)
  - [📦 Installation](#-installation)
  - [🔐 Authentication](#-authentication)
  - [📚 Available Functions](#-available-functions)
  - [📑 Pi-hole API Endpoint Reference](#-pi-hole-api-endpoint-reference)
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

### 🔻 Disable-PiHoleBlocking <!-- omit in toc -->

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

### 🔼 Enable-PiHoleBlocking <!-- omit in toc -->

Re-enables DNS blocking on your Pi-hole.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 📶 Get-PiHoleBlocking <!-- omit in toc -->

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

### 🦾 Get-PiHoleHistory<!-- omit in toc -->

Fetches DNS query history including timestamps and types.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleHistory -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🗂 Get-PiHoleSummary<!-- omit in toc -->

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

### 📊 Get-PiHoleStats<!-- omit in toc -->

Retrieves current usage and performance statistics.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleStats -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🌐 Get-PiHoleDomain<!-- omit in toc -->

Fetches domain lists from the Pi-hole database.

**Parameters:**

* `BaseUrl` – Base URL of the Pi-hole instance
* `Credential` – PSCredential object

```powershell
Get-PiHoleDomain -BaseUrl 'http://pi.hole' -Credential $creds
```

---

### 🖥 Get-PiHoleSystemInfo<!-- omit in toc -->

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

### 🧩 Get-PiHoleVersion<!-- omit in toc -->

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

## 📑 Pi-hole API Endpoint Reference

| Category             | Method | Endpoint                          | Function              | Description                                      |
|----------------------|--------|-----------------------------------|-----------------------|--------------------------------------------------|
| Authentication       | GET    | /auth                             |                       | Check if authentication is required              |
| Authentication       | POST   | /auth                             |                       | Submit password for login                        |
| Authentication       | DELETE | /auth                             |                       | Delete session                                   |
| Authentication       | GET    | /auth/app                         |                       | Create new application password                  |
| Authentication       | DELETE | /auth/session/{id}                |                       | Delete session by ID                             |
| Authentication       | GET    | /auth/sessions                    |                       | List of all current sessions                     |
| Authentication       | GET    | /auth/totp                        |                       | Suggest new TOTP credentials                     |
| Metrics              | GET    | /history                          | Get-PiHoleHistory     | Get activity graph data                          |
| Metrics              | GET    | /history/clients                  |                       | Get per-client activity graph data               |
| Metrics              | GET    | /history/database                  |                       | Get activity graph data (long-term data)         |
| Metrics              | GET    | /history/database/clients         |                       | Get per-client activity graph data (long-term)   |
| Metrics              | GET    | /queries                          |                       | Get queries                                     |
| Metrics              | GET    | /queries/suggestions              |                       | Get query filter suggestions                     |
| Metrics              | GET    | /stats/database/query_types       |                       | Get query types (long-term database)             |
| Metrics              | GET    | /stats/database/summary           | Get-PiHoleSummary     | Get database content details                     |
| Metrics              | GET    | /stats/database/top_clients       |                       | Get top clients (long-term database)             |
| Metrics              | GET    | /stats/database/top_domains       |                       | Get top domains (long-term database)             |
| Metrics              | GET    | /stats/database/upstreams         |                       | Get metrics about upstreams (long-term database) |
| Metrics              | GET    | /stats/query_types                |                       | Get query types                                  |
| Metrics              | GET    | /stats/recent_blocked             |                       | Get most recently blocked domain                 |
| Metrics              | GET    | /stats/summary                    | Get-PiHoleStats       | Get overview of Pi-hole activity                 |
| Metrics              | GET    | /stats/top_clients                |                       | Get top clients                                  |
| Metrics              | GET    | /stats/top_domains                |                       | Get top domains                                  |
| Metrics              | GET    | /stats/upstreams                  |                       | Get metrics about upstreams                      |
| DNS control          | GET    | /dns/blocking                     | Enable-PiHoleBlocking  | Get current blocking status                      |
| DNS control          | POST   | /dns/blocking                     | Enable/Disable-PiHoleBlocking | Change current blocking status           |
| Group management     | POST   | /groups                           |                       | Add new group                                    |
| Group management     | POST   | /groups:batchDelete               |                       | Delete multiple groups                           |
| Group management     | GET    | /groups/{name}                    |                       | Get groups                                       |
| Group management     | PUT    | /groups/{name}                    |                       | Replace group                                    |
| Group management     | DELETE | /groups/{name}                    |                       | Delete group                                     |
| Domain management    | POST   | /domains:batchDelete              |                       | Delete multiple domains                          |
| Domain management    | POST   | /domains/{type}/{kind}            |                       | Add new domain                                   |
| Domain management    | GET    | /domains/{type}/{kind}/{domain}   | Get-PiHoleDomain      | Get domain                                       |
| Domain management    | PUT    | /domains/{type}/{kind}/{domain}   |                       | Replace domain                                   |
| Domain management    | DELETE | /domains/{type}/{kind}/{domain}   |                       | Delete domain                                    |
| Client management    | POST   | /clients                          |                       | Add new client                                   |
| Client management    | POST   | /clients:batchDelete              |                       | Delete multiple clients                          |
| Client management    | GET    | /clients/_suggestions             |                       | Get client suggestions                           |
| Client management    | GET    | /clients/{client}                 |                       | Get clients                                      |
| Client management    | PUT    | /clients/{client}                 |                       | Replace client                                   |
| Client management    | DELETE | /clients/{client}                 |                       | Delete client                                    |
| List management      | POST   | /lists                            |                       | Add new list                                     |
| List management      | POST   | /lists:batchDelete                |                       | Delete lists                                     |
| List management      | GET    | /lists/{list}                     |                       | Get lists                                        |
| List management      | PUT    | /lists/{list}                     |                       | Replace list                                     |
| List management      | DELETE | /lists/{list}                     |                       | Delete list                                      |
| List management      | GET    | /search/{domain}                  |                       | Search domains in Pi-hole's lists                |
| FTL information      | GET    | /endpoints                        |                       | Get list of available API endpoints              |
| FTL information      | GET    | /info/client                      |                       | Get information about requesting client          |
| FTL information      | GET    | /info/database                    |                       | Get info about long-term database                |
| FTL information      | GET    | /info/ftl                         |                       | Get info about various ftl parameters            |
| FTL information      | GET    | /info/host                        |                       | Get info about various host parameters           |
| FTL information      | GET    | /info/login                       |                       | Login page related information                   |
| FTL information      | GET    | /info/messages                    |                       | Get Pi-hole diagnosis messages                   |
| FTL information      | DELETE | /info/messages/{message_id}       |                       | Delete Pi-hole diagnosis message                 |
| FTL information      | GET    | /info/messages/count              |                       | Get count of Pi-hole diagnosis messages          |
| FTL information      | GET    | /info/metrics                     |                       | Get metrics info                                 |
| FTL information      | GET    | /info/sensors                     |                       | Get info about various sensors                   |
| FTL information      | GET    | /info/system                      | Get-PiHoleSystemInfo  | Get info about various system parameters         |
| FTL information      | GET    | /info/version                     | Get-PiHoleVersion     | Get Pi-hole version                              |
| FTL information      | GET    | /logs/dnsmasq                     |                       | Get DNS log content                              |
| FTL information      | GET    | /logs/ftl                         |                       | Get DNS log content                              |
| FTL information      | GET    | /logs/webserver                   |                       | Get DNS log content                              |
| Pi-hole configuration| GET    | /teleporter                       |                       | Export Pi-hole settings                          |
| Pi-hole configuration| POST   | /teleporter                       |                       | Import Pi-hole settings                          |
| Network information  | GET    | /network/devices                  |                       | Get info about the devices in your local network |
| Network information  | DELETE | /network/devices/{device_id}      |                       | Delete a device from the network table           |
| Network information  | GET    | /network/gateway                  |                       | Get info about the gateway of your Pi-hole       |
| Network information  | GET    | /network/interfaces               |                       | Get info about the interfaces of your Pi-hole    |
| Network information  | GET    | /network/routes                   |                       | Get info about the routes of your Pi-hole        |
| Actions              | POST   | /action/flush/arp                 |                       | Flush the network table                          |
| Actions              | POST   | /action/flush/logs                |                       | Flush the DNS logs                               |
| Actions              | POST   | /action/gravity                   |                       | Run gravity                                      |
| Actions              | POST   | /action/restartdns                |                       | Restart pihole-FTL                               |
| PADD                 | GET    | /padd                             |                       | Get summarized data for PADD                     |
| Pi-hole Configuration| GET    | /config                           |                       | Get current configuration of your Pi-hole        |
| Pi-hole Configuration| PATCH  | /config                           |                       | Change configuration of your Pi-hole             |
| Pi-hole Configuration| GET    | /config/{element}                 |                       | Get specific part of current configuration       |
| Pi-hole Configuration| PUT    | /config/{element}/{value}         |                       | Add config array item                            |
| Pi-hole Configuration| DELETE | /config/{element}/{value}         |                       | Delete config array item                         |
| DHCP                 | GET    | /dhcp/leases                      |                       | Get currently active DHCP leases                 |
| DHCP                 | DELETE | /dhcp/leases/{ip}                 |                       | Remove DHCP lease                                |
| Documentation        | GET    | /docs                             |                       | Get the embedded API documentation as HTML       |

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
