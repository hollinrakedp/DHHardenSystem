function Clear-LocalGroupPolicy {
    <#
    .SYNOPSIS
    Clears local Group Policy configurations for user and/or computer settings.

    .DESCRIPTION
    This function allows you to remove user and/or computer settings from the local Group Policy.
    You can specify whether to remove user settings, computer settings, or both.
    The removal of settings is irreversible, so use caution.

    .NOTES
    Name         - Clear-LocalGroupPolicy
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2024-09-28
    Date Updated - 2024-10-22

    .PARAMETER RemoveUserSettings
    Indicates that user settings should be cleared from the local Group Policy.

    .PARAMETER RemoveComputerSettings
    Indicates that computer settings should be cleared from the local Group Policy.

    .EXAMPLE
    Clear-LocalGroupPolicy
    Clears both user and computer settings from the local Group Policy.

    .EXAMPLE
    Clear-LocalGroupPolicy -RemoveUserSettings
    Clears only user settings from the local Group Policy.

    .EXAMPLE
    Clear-LocalGroupPolicy -RemoveComputerSettings
    Clears only computer settings from the local Group Policy.

    #>


    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param(
        [switch]$RemoveUserSettings,
        [switch]$RemoveComputerSettings
    )

    try {
        # Determine if we should clear user and/or computer settings
        $clearUser = $RemoveUserSettings -or (-not $RemoveUserSettings -and -not $RemoveComputerSettings)
        $clearComputer = $RemoveComputerSettings -or (-not $RemoveUserSettings -and -not $RemoveComputerSettings)

        # Clear user settings if specified
        if ($clearUser) {
            if ($PSCmdlet.ShouldProcess("User settings", "Remove")) {
                if (Test-Path "C:\Windows\System32\GroupPolicyUsers") {
                    Remove-Item -Path "C:\Windows\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction Stop
                    Write-Verbose "User settings in local Group Policy configurations cleared successfully."
                } else {
                    Write-Verbose "User settings path does not exist."
                }
            }
        }

        # Clear computer settings if specified
        if ($clearComputer) {
            if ($PSCmdlet.ShouldProcess("Computer settings", "Remove")) {
                if (Test-Path "C:\Windows\System32\GroupPolicy") {
                    Remove-Item -Path "C:\Windows\System32\GroupPolicy" -Recurse -Force -ErrorAction Stop
                    Write-Verbose "Computer settings in local Group Policy configurations cleared successfully."
                } else {
                    Write-Verbose "Computer settings path does not exist."
                }
            }
        }

        # Refresh Group Policy to apply changes
        Write-Verbose "Refreshing Group Policy..."
        gpupdate /force
        Write-Verbose "Group Policy refreshed successfully."
    }
    catch {
        Write-Error "An error occurred while clearing local Group Policy settings: $_"
    }
}