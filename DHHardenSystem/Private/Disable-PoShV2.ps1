function Disable-PoShV2 {
    <#
    .SYNOPSIS
    Disables PowerShell V2.

    .DESCRIPTION
    The script removes the Windows feature for PowerShell V2.

    .NOTES
    Name       : Disable-PoShV2
    Author     : Darren Hollinrake
    Version    : 1.3
    DateCreated: 2018-02-20
    DateUpdated: 2025-11-29
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
                Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: DisablePoshV2: Feature already disabled, Skipping..."
            }
            else {
                Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -Verbose -ErrorAction Stop
                Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: DisablePoshV2: Disabled"
            }
        }
    }
    catch {
        Write-LogEntry -LogLevel ERROR -Tee:$Tee -LogMessage "HardenSystem: DisablePoshV2: Error: $($_.Exception.Message)"
    }
}