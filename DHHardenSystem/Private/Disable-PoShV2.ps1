function Disable-PoShV2 {
    <#
    .SYNOPSIS
    Disables PowerShell V2.

    .DESCRIPTION
    The script removes the Windows feature for PowerShell V2.

    .NOTES   
    Name       : Disable-PoShV2
    Author     : Darren Hollinrake
    Version    : 1.0
    DateCreated: 2018-02-20
    DateUpdated: 2021-08-06
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
    )
    if ($PSCmdlet.ShouldProcess("localhost", "Disable-PoShV2")) {
        if ((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root).State -eq "Disabled") {
            Write-Host "Feature is already removed. Nothing to do..."
        }
        else {
            Write-Host "Removing Feature: $((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root).DisplayName)"
            Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -Verbose
        }
    }
}