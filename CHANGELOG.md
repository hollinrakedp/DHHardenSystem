# DHHardSystem Change Log
## v0.13.0 (2022-06-04)
Adding the mitigations for disabling TLS 1.1 on the systems

### Fixes

### Changes
* Added mitigation (TLS11Client) for disabling TLS 1.1 Client
* Added mitigation (TLS11Server) for disabling TLS 1.1 Server
* Updated Default.json to include the TLS11Server mitigation

### Other

## v0.12.0 (2022-06-04)
Updated to the latest GPO Release (May 2022) for the STIGs used within this module.

### Fixes

### Changes
* STIG - Defender - Updated to v2r4
* SITG - Firefox - Updated to v6r1
* SITG - Windows 10 - Updated to v2r4
* SITG - Server 2016 - Updated to v2r4
* SITG - Server 2019 - Updated to v2r4
### Other
- Invoke-LocalGPO - Corrected statements for Firefox STIG
## v0.11.0 (2022-05-15)
Updated to the latest GPO Release (April 2022) for the STIGs used within this module.

### Fixes
### Changes
* STIG - Google Chrome - Updated to v2r6
* SITG - Office 2019 - Updated to v2r5
* SITG - Office 2016 - Updated combined policies (2022-04)
### Other
## v0.10.0 (2022-03-17)
Fixes

Changes
* STIG - Google Chrome - Updated to v2r5
* STIG - Microsoft Edge - Updated to v1r4
* SITG - Office 2019 - Updated to v2r4
* STIG - Added Firefox v6r1

Other
* Cleanup of typos/misspellings
## v0.9.2 (2021-08-31)
Fixes
* Fixed configuration export where not all values were available
* Fixed configuration export where parameters not configured were producing $null in the saved configuration

Changes
* Added ability to select the UWP apps to be removed
* Added ability to select the scheduled tasks to be disabled

Other
* Cleanup of Verbose statement placement for consistency within Invoke-HardenSystem
* Cleanup of typos

## v0.9.1 (2021-08-12)
Fixes
* Speculative Execution Mitigation names were missing an 's'

Other
* Cleaned up extra code from Enable-EventLog function


## v0.9.0 (2021-08-06)
Initial release