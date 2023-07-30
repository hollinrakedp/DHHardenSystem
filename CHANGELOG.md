# DHHardSystem Change Log
## v1.2.0 (2023-07-30)
### Added

### Changed
* Updated GPO STIGs to to July 2023 release
    * Server 2022 v1r3
    * Edge v1r7
    * Firefox v6r5
    * Office 2016 Various

### Fixed

## v1.1.0 (2023-04-29)
### Added
* STIG versions added to README

### Changed
* Updated GPO STIGs to to April 2023 release
    * Windows 10 v2r6
    * Windows 11 v1r3
    * Server 2016 v2r6
    * Server 2019 v2r6
    * Server 2022 v1r2
    * Google Chrome v2r8
    * Internet Explorer v2r4
    * Office 2019/365 v2r8

### Fixed
* Invoke-LocalGPO: Added OS Options 'Win11' & 'Server2022'

## v1.0.0 (2022-11-05)
### Added
* Added the Windows 11 STIG (v1r2)
* Added the Server 2022 STIG (v1r1)
* Added Markdown documentation

### Changed
* Update GPO STIGs to to Oct 2022 release
    * Windows 10 v2r5
    * Server 2016 v2r5
    * Server 2019 v2r5
    * Edge v1r6
    * Internet Explorer 11 v2r3
    * Google Chrome v2r7
    * Office 2019/365 v2r7
* Cleaned up formatting in CHANGELOG.md
* Removed trailing whitespaces

### Fixed

### v0.15.0 (2022-08-01)
This is the initial release with the capability to log to a file.

### Fixed

### Changed
* Added log file output. The log file is located in 'C:\temp\logs' named 'PowerShell-yyyyMMdd.log'.

### Other

## v0.14.0 (2022-08-01)
Updated to the latest GPO Release (July 2022) for the STIGs used within this module. Added a function to backup the current local group policy of the system.

### Fixed
* Invoke-LocalGPO: Exits if the LGPO executable is not found
### Changed
* Invoke-LocalGPO: Added the Acrobat Pro DC STIG (Parameter: AcrobatProDC)
* Export-LocalGPO: New function added. Backup the local group policy of the system.
* STIG - Internet Exporer 11 - Updated to v2r2
* STIG - Edge - Updated to v1r5
* STIG - Firefox - Updated to v6r3
* STIG - Office 2019/365 - Updated to v2r6

### Other
* Cleanup of spelling, punctuation, and formatting

## v0.13.0 (2022-06-04)
Adding the mitigations for disabling TLS 1.1 on the systems

### Fixed

### Changed
* Added mitigation (TLS11Client) for disabling TLS 1.1 Client
* Added mitigation (TLS11Server) for disabling TLS 1.1 Server
* Updated Default.json to include the TLS11Server mitigation

### Other

## v0.12.0 (2022-06-04)
Updated to the latest GPO Release (May 2022) for the STIGs used within this module.

### Fixed

### Changed
* STIG - Defender - Updated to v2r4
* SITG - Firefox - Updated to v6r1
* SITG - Windows 10 - Updated to v2r4
* SITG - Server 2016 - Updated to v2r4
* SITG - Server 2019 - Updated to v2r4
### Other
- Invoke-LocalGPO - Corrected statements for Firefox STIG
## v0.11.0 (2022-05-15)
Updated to the latest GPO Release (April 2022) for the STIGs used within this module.

### Fixed
### Changes
* STIG - Google Chrome - Updated to v2r6
* SITG - Office 2019 - Updated to v2r5
* SITG - Office 2016 - Updated combined policies (2022-04)
### Other
## v0.10.0 (2022-03-17)
### Fixed

### Changed
* STIG - Google Chrome - Updated to v2r5
* STIG - Microsoft Edge - Updated to v1r4
* SITG - Office 2019 - Updated to v2r4
* STIG - Added Firefox v6r1

### Other
* Cleanup of typos/misspellings
## v0.9.2 (2021-08-31)
### Fixed
* Fixed configuration export where not all values were available
* Fixed configuration export where parameters not configured were producing $null in the saved configuration

### Changed
* Added ability to select the UWP apps to be removed
* Added ability to select the scheduled tasks to be disabled

### Other
* Cleanup of Verbose statement placement for consistency within Invoke-HardenSystem
* Cleanup of typos

## v0.9.1 (2021-08-12)
### Fixed
* Speculative Execution Mitigation names were missing an 's'

### Other
* Cleaned up extra code from Enable-EventLog function


## v0.9.0 (2021-08-06)
Initial release