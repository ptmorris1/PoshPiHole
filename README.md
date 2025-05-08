# PoshPiHole
PowerShell module to interact with the Pi-Hole v6 API

## Description
PoshPiHole provides PowerShell functions to interact with your Pi-hole server, allowing you to manage blocking, view statistics, and analyze query history programmatically.

## Requirements
- PowerShell 7
- Pi-hole v6 or higher
- Network access to your Pi-hole server
- HTTP URL required (https not supported)

## Installation
```powershell
# Install from PowerShell Gallery
Install-Module -Name PoshPiHole -Scope CurrentUser
```

## Authentication
All functions require a PSCredential object. The username can be anything, but the password must match your Pi-hole password:
```powershell
$creds = Get-Credential -UserName admin
```

## Functions

### Disable-PiHoleBlocking
Disables Pi-hole DNS blocking functionality with an optional timer.

Parameters:
- BaseUrl: The base URL of the Pi-hole instance (e.g., http://pi.hole)
- Credential: A PSCredential object containing the Pi-hole password
- Timer: Optional integer value for the timer in seconds. No value sets timer to indefinite.

```powershell
$cred = Get-Credential -UserName admin
Disable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $cred -Timer 15
```

### Enable-PiHoleBlocking
Enables Pi-hole DNS blocking functionality.

Parameters:
- BaseUrl: The base URL of the Pi-hole instance (e.g., http://pi.hole)
- Credential: A PSCredential object containing the Pi-hole password

```powershell
$creds = Get-Credential -UserName admin
Enable-PiHoleBlocking -BaseUrl 'http://pi.hole' -Credential $creds
```

### Get-PiHoleBlocking
Retrieves the current blocking status from Pi-hole.

Parameters:
- BaseUrl: The base URL of the Pi-hole instance
- Credential: A PSCredential object containing the Pi-hole password

Returns a PSCustomObject containing:
- BlockingStatus
- Timer
- Processing time

### Get-PiHoleHistory
Gets query history from Pi-hole including timestamps and query types.

Parameters:
- BaseUrl: The base URL of the Pi-hole instance
- Credential: A PSCredential object containing the Pi-hole password

```powershell
$creds = Get-Credential -UserName admin
Get-PiHoleHistory -BaseUrl 'http://pi.hole' -Credential $creds
```

### Get-PiHoleSummary
Gets database content summary from Pi-hole.

Parameters:
- BaseUrl: The base URL of the Pi-hole instance
- Credential: A PSCredential object containing the Pi-hole password
- From: Start date/time (accepts any format that Get-Date supports)
- Until: End date/time (accepts any format that Get-Date supports)

```powershell
$creds = Get-Credential -UserName admin
# Get summary for last 24 hours
Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds -From (Get-Date).AddDays(-1) -Until (Get-Date)

# Get summary for specific dates
Get-PiHoleSummary -BaseUrl 'http://pi.hole' -Credential $creds -From "2023-01-01" -Until "2023-01-02"
```
