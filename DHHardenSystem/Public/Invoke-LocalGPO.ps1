function Invoke-LocalGPO {
    <#
    .SYNOPSIS
    Applies GPOs against the local system. The settings applied can be seen with the local group policy console (gpedit.msc).

    .DESCRIPTION
    The 'Invoke-LocalGPO' function applies GPO's against the local system. Many of the GPO's provided follow the DISA STIG GPO's and are labeled as 'DISA GPO' in the parameter help. The additional Non-DISA GPO's provided are to configure some common settings or applied against Multi-User Stand Alone (MUSA) system. GPO's are imported using Microsoft's LGPO tool (LGPO.exe). The GPO's have been converted to '*.policyrules' text-based files.

    The DISA GPOs included are based on the January 2025 GPO package.

    Keep in mind the following:
     - For the GPOs that configure the OS, a warning will be displayed if the OS is mismatched but it will apply the selected GPO.
     - For the GPO's that configure applications, no check is make to ensure the application is installed.
     - If the GPO has admx/adml files that are not included with the base installation of Windows, they will show up as extra registry settings when viewed from gpedit.msc
     - If the system is/will be joined to a domain, these local GPO's will not be processed if the following GPO setting is enabled:
          Computer Configuration > Administrative Templates > System > Group Policy: Turn off Local Group Policy objects processing

    .NOTES
    Name         - Invoke-LocalGPO
    Version      - 1.8
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2025-04-13

    .LINK
    https://public.cyber.mil/stigs/gpo/

    .PARAMETER AcrobatProDC
    DISA STIG (v2r1) - Configures Adobe Acrobat Pro (DC) in alignment with the corresponding DISA STIG. This applies both User and Computer settings.

    .PARAMETER AcrobatReaderDC
    DISA STIG (v2r1) - Configured Adobe Acrobat Reader (DC) in alignment with the corresponding DISA STIG. This applies both User and Computer settings.

    .PARAMETER AppLocker
    Custom - Configures AppLocker with a custom policy that allows users to run any Microsoft-signed programs AND any programs in the Program Files directories. Administrators can run anything. Valid values are 'Audit' and 'Enforce'.

    .PARAMETER Chrome
    DISA STIG (v2r10) - Configures Google Chrome in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER Defender
    DISA STIG (v2r4) - Configures Windows Defender AV in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER DisplayLogonInfo
    Custom - After a user logs in successfully, displays the previous logon information (Last Logon Date, Failed logon attempts).

    .PARAMETER Edge
    DISA STIG (v2r2) - Configures Edge (Chromium-based) in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER Firefox
    DISA STIG (v6r5) - Configures Firefox in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER IE11
    DISA STIG (v2r5) - Configures IE11 in alignment with the corresponding DISA STIG. This applies both User and Computer settings.

    .PARAMETER Firewall
    DISA STIG (v2r2) - Configures the Windows firewall in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER NetBanner
    Configures the Microsoft NetBanner application. Valid values are 'FOUO', 'Secret', 'SecretNoForn', 'TopSecret', 'Unclass', and 'Test'.

    .PARAMETER NoPreviousUser
    Custom - Does not display the currently logged on user on the lock screen.

    .PARAMETER Office
    DISA GPO - Configures MS Office using the specified Office STIG. Valid values are '2016', and '2019'. This applies both User and Computer settings.
    For Office 2016, the following STIGs are applied:
        Computer - Skype for Business 2016 - v1r1
        Computer - OneDrive for Business 2016 - v2r3
        Computer - Office System 2016 - v2r2
        User - Access 2016 - v1r1
        User - Excel 2016 - v1r2
        User - Office System 2016 - v2r2
        User - OneDrive for Business - v2r3
        User - Outlook 2016 - v2r3
        User - PowerPoint 2016 - v1r1
        User - Project 2016 - v1r1
        User - Publisher 2016 - v1r3
        User - Visio 2016 - v1r1
        User - Word 2016 - v1r1
    Office 2019/365 (v3r2)

    .PARAMETER ReaderDC
    DISA STIG (v2r1) - Configures Reader DC (Continuous) in alignment with the corresponding DISA STIG. This applies both User and Computer settings.

    .PARAMETER RequireCtrlAltDel
    Custom - Configures the requirement for the user to press Ctrl + Alt + Del on the lock screen to bring up the login prompt.

    .PARAMETER OS
    DISA GPO - Configures the OS using the specified OS STIG. Valid values are 'Win10', 'Win11', 'Server2016', 'Server2019', and 'Server2022'. This applies both User and Computer settings.
        Windows 10 - v3r3
        Windows 11 - v2r5
        Server 2016 - v2r9
        Server 2019 - v3r2 (Computer Settings Only)
        Server 2022 - v2r3 (Computer Settings Only)

    .PARAMETER Tee
    Displays the log output to the console.

    .EXAMPLE
    Invoke-LocalGPO -OS Win10
    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Apply GPO" on target "OS: Win10".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

    This example applies the Win10 STIG to the system. Because the impact to the system is high, confirmation is required before each GPO will be applied.

    .EXAMPLE
    Invoke-LocalGPO -OS Win10 -IE11 -WhatIf
    What if: Performing the operation "Apply GPO" on target "OS: Win10".
    What if: Performing the operation "Apply GPO" on target "IE11: True".

    This example makes use of the 'WhatIf' parameter to view the changes that would occur with the selected parameters.

    .EXAMPLE
    Invoke-LocalGPO -OS Win10 -IE11 -Confirm:$false

    Applies the Win10 and IE11 STIGs to the system without prompting for confirmation.

    #>
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$AcrobatProDC,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$AcrobatReaderDC,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Audit', 'Enforce')]
        [string]$AppLocker,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Chrome,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Defender,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$DisplayLogonInfo,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Edge,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Firefox,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$IE11,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Firewall,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('FOUO', 'Secret', 'SecretNoForn', 'TopSecret', 'Unclass', 'Test')]
        [Alias('NB')]
        [string]$NetBanner,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$NoPreviousUser,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('2016', '2019')]
        [string]$Office,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$ReaderDC,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$RequireCtrlAltDel,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Win10','Win11', 'Server2016', 'Server2019', 'Server2022')]
        [string]$OS,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    if (! (Test-IsAdmin)) {
        Write-Error "Administrator privileges are required to apply GPOs." -ErrorAction Stop
    }

    if ($PSBoundParameters.Keys.Count -eq 0) {
        Write-Error "No parameter was specified." -ErrorAction Stop
    }

    if (!(Get-Command lgpo.exe -ErrorAction SilentlyContinue)) {
        Write-Error "Unable to find 'LGPO.exe'. Ensure it has been downloaded and added to 'PATH'." -ErrorAction Stop
    }

    Write-LogEntry -StartLog
    $ModulePath = $($(Get-Module $($(Get-Command Invoke-HardenSystem).Source)).ModuleBase)
    $CustomGPOPath = Join-Path -Path $ModulePath -ChildPath "GPO\Custom"
    $DoDGPOPath = Join-Path -Path $ModulePath -ChildPath "GPO\DoD"

    switch ($PSBoundParameters.Keys) {
        AcrobatProDC {
            if ($PSCmdlet.ShouldProcess("AcrobatProDC: $AcrobatProDC", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee "Applying GPO: Adobe Acrobat Pro DC"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Adobe Acrobat Pro DC Continuous v2r1.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Adobe Acrobat Pro DC Continuous v2r1.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        AcrobatReaderDC {
            if ($PSCmdlet.ShouldProcess("ReaderDC: $ReaderDC", "Apply GPO")) {
                Write-Verbose "Applying GPO: Adobe Reader DC"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Adobe Acrobat Reader DC Continuous v2r1.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Adobe Acrobat Reader DC Continuous v2r1.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Applocker {
            if ($PSCmdlet.ShouldProcess("AppLocker: $AppLocker", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applocker was specified"
                switch ($AppLocker) {
                    Audit {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: AppLockerAudit"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - AppLocker - Audit.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Enforce {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: AppLockerEnforce"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - AppLocker - Enforce.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                }
            }
        }
        Chrome {
            if ($PSCmdlet.ShouldProcess("Chrome: $Chrome", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Chrome"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Google Chrome v2r10.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Defender {
            if ($PSCmdlet.ShouldProcess("Defender: $Defender", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Defender"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows Defender Antivirus v2r4.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        DisplayLogonInfo {
            if ($PSCmdlet.ShouldProcess("DisplayLogonInfo: $DisplayLogonInfo", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Disable Logon Info"
                & LGPO.exe /p "$CustomGPOPath\Custom - Computer - SYS - Display Previous Logon Info.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Edge {
            if ($PSCmdlet.ShouldProcess("Edge: $Edge", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Edge"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Microsoft Edge v2r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Firefox {
            if ($PSCmdlet.ShouldProcess("Firefox: $Firefox", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Firefox"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Mozilla Firefox v6r5.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        IE11 {
            if ($PSCmdlet.ShouldProcess("IE11: $IE11", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: IE11"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Internet Explorer 11 v2r5.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Internet Explorer 11 v2r5.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Firewall {
            if ($PSCmdlet.ShouldProcess("Firewall: $Firewall", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Firewall"
                & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows Firewall v2r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        NetBanner {
            if ($PSCmdlet.ShouldProcess("NetBanner: $NetBanner", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "NetBanner was specified"
                switch ($NetBanner) {
                    FOUO {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerFOUO"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - UnclassifiedFOUO.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Secret {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerSecret"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - Secret.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    SecretNoForn {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerSecretNoForn"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - SecretNoForn.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Test {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerTest"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - Test.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    TopSecret {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerTopSecret"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - TopSecret.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Unclass {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NetbannerUnclass"
                        & LGPO.exe /p "$CustomGPOPath\Custom - Computer - App - Config - NetBanner - Unclassified.PolicyRules" /v >> "$($env:COMPUTERNAME)_lgpor.log"
                    }
                }
            }
        }
        NoPreviousUser {
            if ($PSCmdlet.ShouldProcess("NoPreviousUser: $NoPreviousUser", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: NoPreviousUser"
                & LGPO.exe /p "$CustomGPOPath\Custom - Computer - SYS - Do Not Display Last User Name.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        Office {
            if ($PSCmdlet.ShouldProcess("Office: $Office", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Office was specified"
                switch ($Office) {
                    '2016' {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Office2016"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Office 2016 - Combined.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                        & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Office 2016 - Combined.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    '2019' {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Office 2019"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Office 2019_365 v3r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                        & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Office 2019_365 v3r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                }
            }
        }
        RequireCtrlAltDel {
            if ($PSCmdlet.ShouldProcess("RequireCtrlAltDel: $RequireCtrlAltDel", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: RequireCtrlAltDel"
                & LGPO.exe /p "$CustomGPOPath\Custom - Computer - SYS - Require Ctrl Alt Del.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
            }
        }
        OS {
            if ($PSCmdlet.ShouldProcess("OS: $OS", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "OS was specified"
                $ActualOS = (Get-CimInstance Win32_OperatingSystem).Caption
                if ($ActualOS -notlike "$($OS -replace '(\D+)(\d+)', '*$1*$2*')") {
                    Write-LogEntry -Tee:$Tee -LogLevel WARN -LogMessage "The OS selected does not match the detected OS."
                }
                switch ($OS) {
                    Win10 {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Win10"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows 10 v3r3.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                        & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Windows 10 v3r3.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Win11 {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Win11"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows 11 v2r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                        & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Windows 11 v2r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Server2016 {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: MS Server 2016"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows Server 2016 Member Server v2r9.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                        & LGPO.exe /p "$DoDGPOPath\User - STIG - DoD Windows Server 2016 Member Server v2r9.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Server2019 {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Server 2019"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows Server 2019 Member Server v3r2.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                    Server2022 {
                        Write-LogEntry -Tee:$Tee -LogMessage "Applying GPO: Server 2022"
                        & LGPO.exe /p "$DoDGPOPath\Computer - STIG - DoD Windows Server 2022 Member Server v2r3.PolicyRules" /v >> "$($env:COMPUTERNAME)_LGPO.log"
                    }
                }
            }
        }
    }
    Write-LogEntry -StopLog
}