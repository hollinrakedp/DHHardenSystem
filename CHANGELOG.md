# Change Log - DHHardenSystem

## v2.3.0 (2026-05-25)

### Added

* Added GPO STIG for Server 2025

### Changed

* Updated GPO STIG to the April 2026 release
  * Internet Explorer 11 v2r7
  * Microsoft Edge v2r5
  * Mozilla Firefox v6r7
  * Server 2019 v3r8
  * Server 2022 v2r8
  * Windows 10 v3r7
  * Windows 11 v2r7
  * Windows Defender AV v2r8

### Fixed

## v2.2.0 (2025-11-30)

### Added

* Custom PolicyRules files can now be imported
  * Place the files in the 'GPO\Custom' subdirectory of the module
  * GPOs are applied in alphanumeric order
* Added parameter '-ExportConfig' to Invoke-HardenSystem
  * Allows for the export of the configuration being applied.

### Changed

* Updated GPO STIGs to the October 2025 release
  * Google Chrome v2r11
  * Internet Explorer 11 v2r6
  * Microsoft Edge v2r3
  * Mozilla Firefox v6r6
  * Office 2019/365 v3r4
  * Server 2016 v2r10
  * Server 2019 v3r6
  * Server 2022 v2r6
  * Windows 10 v3r5
  * Windows 11 v2r5
  * Windows Defender AV v2r6
* Module provided GPOs moved from 'Custom' to 'Module' directory
  * Allows users to place their own custom GPOs in the 'Custom' directory
* Enhanced logging for the lgpo execution
* Standardized logging message output for various functions
* Enhanced error handling for various functions
* Updated various documention

### Fixed

* Various formatting cleanup

## v2.1.0 (2025-02-15)

### Added

### Changed

* Updated GPO STIGs to the January 2025 release
   * Office 2019/365 v3r2
   * Server 2022 v2r3
   * Windows 10 v3r3

### Fixed

* The RC4 mitigation was creating additional sub-keys due to the interpretation of the forward slash as being a path separator. Reverted to use the older 'reg' command to eliminate the issue and create they entire path correctly.

## v2.0.0 (2024-11-03)

### Added

* Added new functions
  * Get-LGPO - Downloads the LGPO.exe file
  * Clear-LocalGroupPolicy - Clears the local group policy on the system

### Changed

* Updated GPO STIGs to the October 2024 release
  * Google Chrome v2r10
  * Microsoft Edge v2r2
  * Office 2019/365 v3r1
  * Windows 10 v3r2
  * Windows 11 v2r2
  * Server 2016 v2r9
  * Server 2019 v3r2
    * User settings removed
  * Server 2022 v2r2
* Invoke-LocalGPO
  * Added a warning when applying an OS STIG that does not match the detected OS. It does not stop the OS STIG from applying.
* Updated the default configuration
  * Win11 is now the default OS
* Export-LocalGPO
  * Added admin check; updated documentation
* Mitigations
  * Refactored internal functions
  * Added documentation

### Fixed

* Cleaned up logging function output during 'WhatIf' operations

## v1.4.0 (2024-01-24)

### Added

* Added additional error handling to multiple functions
* Added parameter validation
  * Enable-EventLog
* Added a check for admin rights when calling 'Invoke-LocalGPO'

### Changed

* Log name now defaults to 'DHHardenSystem-yyyyMMdd.log'
* Updated comment-based help
* Updated GPO STIGs to the January 2024 release
  * Internet Explorer 11 v2r5
  * Windows Firewall v2r2

### Fixed

* When running a command with '-WhatIf' support, the logging function will no longer create the log file
* Fixed instances where variables had different variations in case

## v1.3.0 (2023-11-12)
### Added

### Changed

* Updated GPO STIGs to the October 2023 release
  * Server 2016 v2r7
  * Server 2019 v2r8
  * Server 2022 v1r4
  * Windows 10 v2r8
  * Windows 11 v1r5
  * Office 2019/365 v2r11

### Fixed

## v1.2.0 (2023-07-30)

### Added

### Changed

* Updated GPO STIGs to the July 2023 release
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
