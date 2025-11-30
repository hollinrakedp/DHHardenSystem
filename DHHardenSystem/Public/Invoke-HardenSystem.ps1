function Invoke-HardenSystem {
    <#
    .SYNOPSIS
    Quickly harden the local Windows system with various security configurations.

    .DESCRIPTION
    The Invoke-HardenSystem function allows you to quickly apply security configurations to the local Windows system. It supports various options to enhance system security, such as applying Group Policy settings, configuring Data Execution Prevention (DEP), disabling PowerShell v2, managing scheduled tasks and services, enabling event logs, setting local user password expiration, applying mitigations, and removing UWP applications.

    .NOTES
    Name         - Invoke-HardenSystem
    Version      - 1.2
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2025-11-30

    .PARAMETER ApplyGPO
    Applies settings against the Local Group Policy. See 'Invoke-LocalGPO' for additional information on the parameters that can be called.
    To import custom Policy Analyzer rules, include `CustomGPO = $true` in the hashtable passed to `-ApplyGPO`. This will call `Invoke-LocalGPO -CustomGPO` and import any `.PolicyRules` files in `GPO\\Custom`.

    .PARAMETER DEP
    Configures the Data Execution Prevention policy. Valid values are 'OptIn', 'OptOut', 'AlwaysOn', 'AlwaysOff'.
    Note: Changes to DEP require a reboot.

    WARNING: This does not check to see if BitLocker is enabled on the system drive. If it is, be sure to suspend BitLocker before rebooting or it will prompt for a recovery key.

    .PARAMETER DisablePoShV2
    Remove the Windows Feature PowerShell v2 if it is installed.

    .PARAMETER DisableScheduledTask
    Disables a user supplied list of scheduled tasks. This can include both individual scheduled tasks and those residing in a specific path.

    .PARAMETER DisableService
    Disables a user supplied list of services. Provide the name of the service(s) (not the display name).

    .PARAMETER EnableLog
    Enables the Windows event log for each specified log name.

    .PARAMETER LocalUserPasswordExpires
    Enables password expiration for any local accounts that are enabled and do not have a password expiration.

    .PARAMETER Mitigation
    Enables the mitigation for the specified items.

    .PARAMETER RemoveWinApp
    Removes the supplied list of UWP Applications from the system.

    .PARAMETER ExportConfig
    When specified, exports the configuration (the parameters supplied) to a JSON file using 'Export-HardenSystemConfig'.
    Provide a file path or directory. If a directory is provided, an automatic filename is used (HardenSystemConfig-yyyyMMdd.json).
    Respects -WhatIf (no file created when -WhatIf is used). If only -ExportConfig is supplied with no other configuration parameters, a warning is issued and no file is created.

    .PARAMETER Tee
    Switch parameter that, when specified, enables logging to both the console and a log file.

    .EXAMPLE
    Invoke-HardenSystem -DEP OptOut
    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Set-DEP OptOut" on target "localhost".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

    This example will set DEP on the system to 'OptOut'. Because the impact to the system is high, confirmation is required before each action will run.

    .EXAMPLE
    Invoke-HardenSystem -ApplyGPO @{OS = 'Win10'; IE11 = $true} -DEP OptOut -LocalUserPasswordExpires -WhatIf
    What if: Performing the operation "Apply GPO" on target "OS: Win10".
    What if: Performing the operation "Apply GPO" on target "IE11: True".
    What if: Performing the operation "Set-DEP OptOut" on target "localhost".
    What if: Performing the operation "Set-LocalUserPasswordExpires" on target "MyLocalUser".

    This example makes use of the 'WhatIf' parameter to view the changes that would occur with the selected parameters.

    .EXAMPLE
    Import-HardenSystemConfig .\Default.json | Invoke-HardenSystem -Confirm:$False

    This example imports the configuration from the file 'Default.json' located in the current directory and passes the configuration to the 'Invoke-HardenSystem' function. No confirmation is required before changes are made to the system.

    .EXAMPLE
    Invoke-HardenSystem -ApplyGPO @{ OS = 'Win11'; Defender = $true; CustomGPO = $true } -Confirm:$false

    Applies selected built-in GPOs (Windows Defender, Windows 11 STIG) and then imports and applies any custom '.PolicyRules' files placed under 'GPO\Custom' in the module. The `CustomGPO` flag is passed through to `Invoke-LocalGPO` automatically.

    .EXAMPLE
    Invoke-HardenSystem -ApplyGPO @{ OS = 'Win11'; Defender = $true } -DEP OptOut -DisablePoShV2 -ExportConfig .\AppliedConfig.json -Confirm:$false

    Hardens the system with the provided parameters and exports the configuration used to 'AppliedConfig.json' for reuse.

    #>
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [array]$ApplyGPO,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('AlwaysOff', 'AlwaysOn', 'OptIn', 'OptOut')]
        [string]$DEP,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$DisablePoShV2,
        [Parameter(ValueFromPipelineByPropertyName)]
        [array]$DisableScheduledTask,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$DisableService,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$EnableLog,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$LocalUserPasswordExpires,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$Mitigation,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$RemoveWinApp,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('ExportConfigPath')]
        [string]$ExportConfig,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    begin {
        $SplatLogEntry = @{
            Tee     = $Tee
            WhatIf  = $WhatIfPreference
        }
        Write-LogEntry @SplatLogEntry -StartLog
    }

    process {
        switch ($PSBoundParameters.Keys) {
            ApplyGPO {
                $GPO = @{}
            ($ApplyGPO | ConvertTo-Json | ConvertFrom-Json).psobject.properties | ForEach-Object { $GPO[$_.Name] = $_.Value }
                $GPOString = $(foreach ($kvp in $GPO.GetEnumerator()) { $kvp.Key + ':' + $kvp.Value }) -join ', '
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: ApplyGPO"
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: ApplyGPO: Passing GPOs: $GPOString"
                Invoke-LocalGPO @GPO -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            DEP {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: DEP"
                Set-DEP -Policy $DEP -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            DisablePoShV2 {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: DisablePoshV2"
                if ($PSCmdlet.ShouldProcess("localhost", "Disable-PoShV2")) {
                    Disable-PoShV2 -WhatIf:$WhatIfPreference -Tee:$Tee
                }
            }
            DisableScheduledTask {
                $ScheduledTask = @{}
            ($DisableScheduledTask | ConvertTo-Json | ConvertFrom-Json).psobject.properties | ForEach-Object { $ScheduledTask[$_.Name] = $_.Value }
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: DisableScheduledTasks"
                Set-ScheduledTaskDisabled @ScheduledTask -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            DisableService {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: DisableServices"
                Set-ServiceDisabled -Name $DisableService -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            EnableLog {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: EnableLog"
                Enable-EventLog -LogName $EnableLog -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            LocalUserPasswordExpires {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: LocalUserPasswordExpires"
                Set-LocalUserPasswordExpires -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            Mitigation {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: Mitigation"
                foreach ($Mitigate in $Mitigation) {
                    & $Mitigate -WhatIf:$WhatIfPreference -Tee:$Tee
                }
            }
            RemoveWinApp {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: RemoveWinApp"
                Remove-WinApp -App $RemoveWinApp -WhatIf:$WhatIfPreference -Tee:$Tee
            }
            ExportConfig {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: Option Selected: ExportConfig"
                # Build hashtable of configuration parameters (exclude meta / control params)
                $ExcludeParams = 'ExportConfig','Tee','Confirm','WhatIf','Verbose','Debug','ErrorAction','WarningAction','OutVariable','OutBuffer','PipelineVariable'
                $ExportParams = @{}
                foreach ($Key in $PSBoundParameters.Keys) {
                    if ($ExcludeParams -notcontains $Key) {
                        switch ($Key) {
                            'DisablePoShV2' { $ExportParams[$Key] = $PSBoundParameters[$Key].IsPresent }
                            'LocalUserPasswordExpires' { $ExportParams[$Key] = $PSBoundParameters[$Key].IsPresent }
                            default { $ExportParams[$Key] = $PSBoundParameters[$Key] }
                        }
                    }
                }
                if ($ExportParams.Count -eq 0) {
                    Write-LogEntry @SplatLogEntry -LogLevel WARN -LogMessage "HardenSystem: ExportConfig: No configuration parameters supplied - skipping file creation."
                }
                else {
                    try {
                        Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: ExportConfig: Exporting configuration to: $ExportConfig"
                        Export-HardenSystemConfig @ExportParams -FilePath $ExportConfig -Confirm:$false -Verbose:$false -WhatIf:$WhatIfPreference | Out-Null
                    }
                    catch {
                        Write-LogEntry @SplatLogEntry -LogLevel ERROR -LogMessage "HardenSystem: ExportConfig: Error exporting configuration - $($_.Exception.Message)"
                    }
                }
            }
        }
    }

    end {
        Write-LogEntry @SplatLogEntry -StopLog
    }
}
