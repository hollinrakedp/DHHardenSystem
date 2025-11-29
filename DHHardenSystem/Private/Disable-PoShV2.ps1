function Disable-PoShV2 {
    <#
    .SYNOPSIS
    Disables PowerShell V2.

    .DESCRIPTION
    The script removes the Windows feature for PowerShell V2.

    .NOTES
    Name       : Disable-PoShV2
    Author     : Darren Hollinrake
    Version    : 1.2
    DateCreated: 2018-02-20
    DateUpdated: 2025-11-28
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    try {
        if ($PSCmdlet.ShouldProcess("localhost", "Disable-PoShV2")) {
            $Feature = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -ErrorAction Stop
            if ($Feature.State -eq "Disabled") {
                Write-LogEntry -Tee:$Tee -LogMessage "Disable: Windows Feature: $($Feature.DisplayName): Feature already disabled, Skipping..."
            }
            else {
                Write-LogEntry -Tee:$Tee -LogMessage "Disable: Windows Feature: $($Feature.DisplayName): Disabling"
                Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -Verbose -ErrorAction Stop
            }
        }
    }
    catch {
        Write-LogEntry -LogLevel ERROR -Tee:$Tee -LogMessage "Disable: Windows Feature: $($Feature.DisplayName): Error: $($_.Exception.Message)"
    }
}