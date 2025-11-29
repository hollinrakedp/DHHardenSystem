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
    Version      - 1.10
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2025-11-28

    .LINK
    https://public.cyber.mil/stigs/gpo/

    .PARAMETER AcrobatProDC
    DISA STIG (v2r1) - Configured Adobe Acrobat Pro (DC) in alignment with the corresponding DISA STIG. This applies both User and Computer settings.

    .PARAMETER AppLocker
    Module Provided - Configures AppLocker with a custom policy that allows users to run any Microsoft-signed programs AND any programs in the Program Files directories. Administrators can run anything. Valid values are 'Audit' and 'Enforce'.

    .PARAMETER Chrome
    DISA STIG (v2r10) - Configures Google Chrome in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER Defender
    DISA STIG (v2r4) - Configures Windows Defender AV in alignment with the corresponding DISA STIG. This applies Computer settings.

    .PARAMETER DisplayLogonInfo
    Module Provided - After a user logs in successfully, displays the previous logon information (Last Logon Date, Failed logon attempts).

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
    Module Provided - Does not display the currently logged on user on the lock screen.

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
    Module Provided - Configures the requirement for the user to press Ctrl + Alt + Del on the lock screen to bring up the login prompt.

    .PARAMETER OS
    DISA GPO - Configures the OS using the specified OS STIG. Valid values are 'Win10', 'Win11', 'Server2016', 'Server2019', and 'Server2022'. This applies both User and Computer settings.
        Windows 10 - v3r3
        Windows 11 - v2r2
        Server 2016 - v2r9
        Server 2019 - v3r2 (Computer Settings Only)
        Server 2022 - v2r3 (Computer Settings Only)

    .PARAMETER CustomGPO
    Imports any custom Policy Analyzer .PolicyRules files located in the 'GPO\Custom' folder. These files are applied to the system in alphabetical order after all other items have been applied.

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
        [ValidateSet('Win10', 'Win11', 'Server2016', 'Server2019', 'Server2022')]
        [string]$OS,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$CustomGPO,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    if (! (Test-IsAdmin)) {
        Write-Error "Administrator privileges are required to apply GPOs." -ErrorAction Stop
    }

    if ($PSBoundParameters.Keys.Count -eq 0) {
        Write-Error "No parameter was specified." -ErrorAction Stop
    }

    if (-not $WhatIfPreference) {
        if (!(Get-Command lgpo.exe -ErrorAction SilentlyContinue)) {
            Write-Error "Unable to find 'LGPO.exe'. Ensure it has been downloaded and added to 'PATH'." -ErrorAction Stop
        }
    }

    $GPOLogFile = "DHHardenSystem_$($env:COMPUTERNAME)_$(Get-Date -Format yyyyMMdd)_LGPO.log"
    $GPOFullLogPath = Join-Path -Path $Script:LogPath -ChildPath $GPOLogFile
    Write-LogEntry -StartLog
    $ModulePath = $($(Get-Module $($(Get-Command Invoke-HardenSystem).Source)).ModuleBase)
    $CustomGPOPath = Join-Path -Path $ModulePath -ChildPath "GPO\Custom"
    $DoDGPOPath = Join-Path -Path $ModulePath -ChildPath "GPO\DoD"
    $ModuleGPOPath = Join-Path -Path $ModulePath -ChildPath "GPO\Module"

    $Results = @()
    switch ($PSBoundParameters.Keys) {
        AcrobatProDC {
            if ($PSCmdlet.ShouldProcess("AcrobatProDC: $AcrobatProDC", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee "GPO: Apply - Adobe Acrobat Pro DC"
                $Results += Import-LGPOPolicyRules -Name "AcrobatProDC (Computer)" -PolicyRulesPath "$ModuleGPOPath\Computer - STIG - DoD Adobe Acrobat Pro DC Continuous v2r1.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                $Results += Import-LGPOPolicyRules -Name "AcrobatProDC (User)" -PolicyRulesPath "$ModuleGPOPath\User - STIG - DoD Adobe Acrobat Pro DC Continuous v2r1.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Applocker {
            if ($PSCmdlet.ShouldProcess("AppLocker: $AppLocker", "Apply GPO")) {
                switch ($AppLocker) {
                    Audit {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - AppLocker (Audit)"
                        $Results += Import-LGPOPolicyRules -Name "AppLocker (Audit)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - AppLocker - Audit.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Enforce {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - AppLocker (Enforce)"
                        $Results += Import-LGPOPolicyRules -Name "AppLocker (Enforce)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - AppLocker - Enforce.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                }
            }
        }
        Chrome {
            if ($PSCmdlet.ShouldProcess("Chrome: $Chrome", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Google Chrome"
                $Results += Import-LGPOPolicyRules -Name "Chrome (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Google Chrome v2r10.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Defender {
            if ($PSCmdlet.ShouldProcess("Defender: $Defender", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows Defender Antivirus"
                $Results += Import-LGPOPolicyRules -Name "Defender (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows Defender Antivirus v2r4.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        DisplayLogonInfo {
            if ($PSCmdlet.ShouldProcess("DisplayLogonInfo: $DisplayLogonInfo", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Display Previous Logon Info"
                $Results += Import-LGPOPolicyRules -Name "Display Previous Logon Info (Computer)" -PolicyRulesPath "$ModuleGPOPath\Computer - SYS - Display Previous Logon Info.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Edge {
            if ($PSCmdlet.ShouldProcess("Edge: $Edge", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Microsoft Edge"
                $Results += Import-LGPOPolicyRules -Name "Edge (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Microsoft Edge v2r2.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Firefox {
            if ($PSCmdlet.ShouldProcess("Firefox: $Firefox", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Mozilla Firefox"
                $Results += Import-LGPOPolicyRules -Name "Firefox (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Mozilla Firefox v6r5.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        IE11 {
            if ($PSCmdlet.ShouldProcess("IE11: $IE11", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Internet Explorer 11"
                $Results += Import-LGPOPolicyRules -Name "IE11 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Internet Explorer 11 v2r5.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                $Results += Import-LGPOPolicyRules -Name "IE11 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Internet Explorer 11 v2r5.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Firewall {
            if ($PSCmdlet.ShouldProcess("Firewall: $Firewall", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows Firewall"
                $Results += Import-LGPOPolicyRules -Name "Windows Firewall (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows Firewall v2r2.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        NetBanner {
            if ($PSCmdlet.ShouldProcess("NetBanner: $NetBanner", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "NetBanner: Parameter specified"
                switch ($NetBanner) {
                    FOUO {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (FOUO)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (FOUO)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - UnclassifiedFOUO.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Secret {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (Secret)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (Secret)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - Secret.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    SecretNoForn {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (SecretNoForn)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (SecretNoForn)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - SecretNoForn.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Test {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (Test)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (Test)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - Test.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    TopSecret {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (TopSecret)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (TopSecret)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - TopSecret.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Unclass {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - NetBanner (Unclass)"
                        $Results += Import-LGPOPolicyRules -Name "NetBanner (Unclass)" -PolicyRulesPath "$ModuleGPOPath\Computer - App - Config - NetBanner - Unclassified.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                }
            }
        }
        NoPreviousUser {
            if ($PSCmdlet.ShouldProcess("NoPreviousUser: $NoPreviousUser", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Do Not Display Last User Name"
                $Results += Import-LGPOPolicyRules -Name "Do Not Display Last User Name (Computer)" -PolicyRulesPath "$ModuleGPOPath\Computer - SYS - Do Not Display Last User Name.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        Office {
            if ($PSCmdlet.ShouldProcess("Office: $Office", "Apply GPO")) {
                switch ($Office) {
                    '2016' {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Office 2016"
                        $Results += Import-LGPOPolicyRules -Name "Office 2016 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Office 2016 - Combined.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                        $Results += Import-LGPOPolicyRules -Name "Office 2016 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Office 2016 - Combined.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    '2019' {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Office 2019/365"
                        $Results += Import-LGPOPolicyRules -Name "Office 2019/365 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Office 2019_365 v3r4.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                        $Results += Import-LGPOPolicyRules -Name "Office 2019/365 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Office 2019_365 v3r4.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                }
            }
        }
        ReaderDC {
            if ($PSCmdlet.ShouldProcess("ReaderDC: $ReaderDC", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Adobe Reader DC"
                $Results += Import-LGPOPolicyRules -Name "Adobe Reader DC (Computer)" -PolicyRulesPath "$ModuleGPOPath\Computer - STIG - DoD Adobe Acrobat Reader DC Continuous v2r1.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                $Results += Import-LGPOPolicyRules -Name "Adobe Reader DC (User)" -PolicyRulesPath "$ModuleGPOPath\User - STIG - DoD Adobe Acrobat Reader DC Continuous v2r1.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        RequireCtrlAltDel {
            if ($PSCmdlet.ShouldProcess("RequireCtrlAltDel: $RequireCtrlAltDel", "Apply GPO")) {
                Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Require Ctrl Alt Del"
                $Results += Import-LGPOPolicyRules -Name "Require Ctrl Alt Del (Computer)" -PolicyRulesPath "$ModuleGPOPath\Computer - SYS - Require Ctrl Alt Del.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
            }
        }
        OS {
            if ($PSCmdlet.ShouldProcess("OS: $OS", "Apply GPO")) {
                $ActualOS = (Get-CimInstance Win32_OperatingSystem).Caption
                if ($ActualOS -notlike "$($OS -replace '(\D+)(\d+)', '*$1*$2*')") {
                    Write-LogEntry -Tee:$Tee -LogLevel WARN -LogMessage "The OS selected does not match the detected OS."
                }
                switch ($OS) {
                    Win10 {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows 10"
                        $Results += Import-LGPOPolicyRules -Name "Windows 10 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows 10 v3r3.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                        $Results += Import-LGPOPolicyRules -Name "Windows 10 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Windows 10 v3r3.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Win11 {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows 11"
                        $Results += Import-LGPOPolicyRules -Name "Windows 11 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows 11 v2r2.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                        $Results += Import-LGPOPolicyRules -Name "Windows 11 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Windows 11 v2r2.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Server2016 {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows Server 2016"
                        $Results += Import-LGPOPolicyRules -Name "Windows Server 2016 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows Server 2016 Member Server v2r9.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                        $Results += Import-LGPOPolicyRules -Name "Windows Server 2016 (User)" -PolicyRulesPath "$DoDGPOPath\User - STIG - DoD Windows Server 2016 Member Server v2r9.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Server2019 {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows Server 2019"
                        $Results += Import-LGPOPolicyRules -Name "Windows Server 2019 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows Server 2019 Member Server v3r2.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                    Server2022 {
                        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Apply - Windows Server 2022"
                        $Results += Import-LGPOPolicyRules -Name "Windows Server 2022 (Computer)" -PolicyRulesPath "$DoDGPOPath\Computer - STIG - DoD Windows Server 2022 Member Server v2r3.PolicyRules" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                    }
                }
            }
        }
    }

    if ($CustomGPO) {
        Write-LogEntry -Tee:$Tee -LogMessage "GPO: Custom: Importing files"
        $CustomGPOFiles = Get-ChildItem -Path $CustomGPOPath -Filter *.PolicyRules | Sort-Object Name
        if ($CustomGPOFiles.Count -eq 0) {
            Write-LogEntry -Tee:$Tee -LogLevel WARN -LogMessage "GPO: Custom: No PolicyRules files found - Skipping"
        }
        else {
            foreach ($GPOFile in $CustomGPOFiles) {
                if ($PSCmdlet.ShouldProcess("GPO: Custom: $($GPOFile.Name)", "Apply GPO")) {
                    Write-LogEntry -Tee:$Tee -LogMessage "GPO: Custom: Apply - $($GPOFile.Name)"
                    $Results += Import-LGPOPolicyRules -Name "Custom: $($GPOFile.Name)" -PolicyRulesPath "$($GPOFile.FullName)" -LogFilePath "$GPOFullLogPath" -WhatIf:$WhatIfPreference -Tee:$Tee
                }
            }
        }
    }

    $Summary = [ordered]@{
        Total = $Results.Count
        Success = ($Results | Where-Object { $_.Success }).Count
        Failed = ($Results | Where-Object { $_.Executed -and -not $_.Success }).Count
        Skipped = ($Results | Where-Object { $_.Status -eq 'Skipped' }).Count
        NotFound = ($Results | Where-Object { $_.Status -eq 'NotFound' }).Count
        DependencyMissing = ($Results | Where-Object { $_.Status -eq 'DependencyMissing' }).Count
    }
    Write-LogEntry -Tee:$Tee -LogMessage ("LGPO Summary: Total:{0} Success:{1} Failed:{2} Skipped:{3} NotFound:{4} DependencyMissing:{5}" -f $Summary.Total,$Summary.Success,$Summary.Failed,$Summary.Skipped,$Summary.NotFound,$Summary.DependencyMissing)
    Write-LogEntry -StopLog
}