function SpeculativeExecution{
    <#
    .SYNOPSIS
    Configures Speculative Execution mitigations.

    .NOTES
    Name         - SpeculativeExecution
    Version      - 1.3
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2025-11-29

    https://support.microsoft.com/en-us/help/4072698/windows-server-guidance-to-protect-against-the-speculative-execution

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: Speculative Execution - Begin"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
    if (!(Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }

    $Settings = @(
        @{ Name = 'FeatureSettingsOverride'; Value = 72 },
        @{ Name = 'FeatureSettingsOverrideMask'; Value = 3 }
    )

    foreach ($Setting in $Settings) {
        $ItemProperty = @{ Path = $RegPath; Name = $Setting.Name; Value = $Setting.Value; PropertyType = 'DWORD'; Force = $true }
        if ($PSCmdlet.ShouldProcess("$RegPath::$($Setting.Name)", 'Set registry value')) {
            Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: Speculative Execution - Setting $($Setting.Name)=$($Setting.Value)"
            New-ItemProperty @ItemProperty | Out-Null
        }
    }

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: Speculative Execution - Complete"
}
