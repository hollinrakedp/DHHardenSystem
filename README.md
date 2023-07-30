# DHHardenSystem
The purpose of this module is to allow for the quick hardening of a basic installation of Windows 10, Windows 11, Server 2016, Server 2019, and Server 2022. Hardening is based primarily on DISA Security Technical Implementation Guides (STIGs). It's designed to be portable, work completely offline, and for use on stand-alone/isolated/air-gapped systems. There is significant flexibility in how much or how little hardening is applied to the system based on the parameters provided.

This module uses a few different methods for hardening a system. The primary method is the application of GPOs against the local group policy. The GPO's provided include DISA STIG GPOs and custom GPOs. There are also additional configuration items that can be set which are not controlled via GPO. Finally, there are mitigations that can be applied for items such as disabling old and insecure ciphers and protocols.

## Dependencies
This module has a single outside dependency.
- LGPO.exe
    - This is provided by Microsoft as part of the Secuirty Compliance Toolkit (SCT). See the 'Resources' section for a link to the download.
    - It is expected that 'LGPO.exe' is available from your system's PATH. The module will automatically add the 'LGPO' folder within the module to this location when it is loaded. So long as you add the file to this location, no additional configuration is needed.


## Quick Start
For a Windows 10 system, you can follow the following steps:
1. Download this module
1. Copy the module to the system to be hardened
    - Module Location: C:\Temp\DHHardenSystem
1. Download LGPO.zip (https://www.microsoft.com/en-us/download/details.aspx?id=55319)
1. Extract 'LGPO.exe' from LGPO.zip and place it within the LGPO folder
    - DHHardenSystem/LGPO
1. Run PowerShell as Administrator
1. Import the module
    - Import-Module C:\Temp\DHHardenSystem\DHHardenSystem.psd1
1. Harden the system with the default configuration file
    - Import-HardenSystemConfig -FilePath "C:\Temp\DHHardenSystem\Default.json" | Invoke-HardenSystem -Confirm:$false


## Available Hardening/Configuration Items
As described above, there are multiple ways this module hardens the system. Here is an overview into all the changes possible via this module. Additional information can be found in the help for the functions themselves.

### GPOs
There are two type of GPOs available: DISA and Custom. The DISA GPO's are based off the July 2023 GPO Package. The custom GPOs configure additional items configurable via GPO but not contained within existing STIGs.

The list of currently available GPO's in this module:
- DISA
    - Application - Adobe Reader DC - v2r1
    - Application - Google Chrome - v2r8
    - Application - Internet Explorer 11 - v2r4
    - Application - Edge - v1r7
    - Application - Firefox - v6r4
    - Application - Office 2016 - Various
    - Application - Office 2019/M365 - v2r8
    - Application - Windows Defender Antivirus - v2r4
    - Application - Windows Firewall - v1r7
    - OS - Windows 10 - v2r6
    - OS - Windows 11 - v1r3
    - OS - Server 2016 - v2r6
    - OS - Server 2019 - v2r6
    - OS - Server 2022 - v1r3
- Custom
    - AppLocker Audit
    - AppLocker Enforce
    - DisplayLogonInfo
    - NetBanner
    - NoPreviousUser
    - RequireCtrlAltDel

Most of the GPOs are self-explainatory. For additional information see the help provided in 'Invoke-LocalGPO'.

### Mitigations
The items included in this category are typically found via a vulnerability scanner. They are not typically a configuration item called out directly in the STIG. The list of currently available mitigations is as follows:
- RC4
    - Disables the RC4 cipher on the system (Bar Mitzvah)
- Speculative Execution
    - Enables Speculative Execution mitigations (Spectre/Meltdown)
- SSL3Client
    - Disables the SSL 3.0 client protocol on the system (POODLE)
- SSL3Server
    - Disables the SSL 3.0 server protocol on the system (POODLE)
- TLS1Client
    - Disables the TLS 1.0 client protocol on the system
- TLS1Server
    - Disables the TLS 1.0 server protocol on the system
- TLS11Client
    - Disables the TLS 1.1 client protocol on the system
- TLS11Server
    - Disables the TLS 1.1 server protocol on the system
- TripleDES
    - Disables the TripleDES algorithm (SWEET32)

### Other Items
This category includes additional settings that aren't set via GPO. These include the following:
- Disable PowerShell v2
    - STIG requirement to remove this from the system.
- Enables Event Logs
    - Allows the enablement of Windows Event Logs that may not be enabled by default. The user must supply the name of the logs to be enabled.
- Remove UWP Applications
    - Removes a user supplied list of UWP applications from the system.
- Configures DEP
    - Allows the user to set the Data Execution Prevention policy on the system. The STIG requires at least 'OptOut'.
- Disable Scheduled Tasks
    - Disables a user supplied list of scheduled tasks on the system.
- Disable Services
    - Stops and disables the list of services provided.
- Set Local User Passwords to Expire
    - Checks the local accounts on the system for users that are enabled and have a password that is set to never expire. For those that match the criteria, they will be reconfigured to expire.


## Functions
Below is a brief overview of the primary functions in this module.

### Invoke-HardenSystem
This is the main function providing control of the hardening process. It performs all the calls to the public and private functions to apply the configurations requested to the system. 

### Invoke-LocalGPO
This applies the GPOs against the local system. Even though the tool is capable of importing GPO backups directly, they've been flattened into '*.POLICYRULES' files for ease of use.

### Export-HardenSystemConfig
This is used to create a configuration file that can then be imported and passed to 'Invoke-HardenSystem'. The configuration file is saved as a JSON file. The primary use of this is to allow the creation of specific baselines that can allow for easily repeatable results.

### Import-HardenSystemConfig
This is useds to import a configuration file created with the 'Export-HardenSystemConfig' command. It can be piped directly to 'Invoke-HardenSystem'.

### Export-LocalGPO
This is used to export the system's current Local Group Policy configuration.

## To-Do
There are a few items I'm looking to possibly add to this module. This list is mainly to remind myself and there's no guarantees it'll be added at any point.
- Invoke-LocalGPO: Allow import of custom PolicyFiles
- Invoke-HardenSystem: Add parameter to export the configuration being applied
- Export of the current system configuration


## Resources
Public DoD Cyber Exchange
- Public Page: https://public.cyber.mil/
- GPO Package: https://public.cyber.mil/stigs/gpo/
- STIG Library: https://public.cyber.mil/stigs/compilations/

Microsoft Security Compliance Toolkit
- Documentation: https://docs.microsoft.com/en-us/windows/security/threat-protection/security-compliance-toolkit-10
- Download: https://www.microsoft.com/en-us/download/details.aspx?id=55319
