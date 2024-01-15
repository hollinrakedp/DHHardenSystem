function Disable-PoShV2 {
    <#
    .SYNOPSIS
    Disables PowerShell V2.

    .DESCRIPTION
    The script removes the Windows feature for PowerShell V2.

    .NOTES
    Name       : Disable-PoShV2
    Author     : Darren Hollinrake
    Version    : 1.1
    DateCreated: 2018-02-20
    DateUpdated: 2024-01-15
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
                Write-LogEntry -Tee:$Tee -LogMessage "PowerShell v2 Feature is already removed. Nothing to do..."
            }
            else {
                Write-LogEntry -Tee:$Tee -LogMessage "Removing Feature: $($Feature.DisplayName)"
                Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -Verbose -ErrorAction Stop
            }
        }
    }
    catch {
        Write-LogEntry -LogLevel ERROR -Tee:$Tee -LogMessage "Error occurred: $($_.Exception.Message)"
    }
}