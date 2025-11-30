function Set-ScheduledTaskDisabled {
    <#
    .SYNOPSIS
    Disables a list of scheudled tasks.

    .DESCRIPTION
    This script will disabled unnecessary scheduled tasks on the system it's ran. You can specify a list of task names, list of
    task paths, or both.

    .NOTES
    Name        : Set-ScheduledTaskDisabled
    Author      : Darren Hollinrake
    Version     : 1.2
    DateCreated : 2018-08-02
    DateUpdated : 2025-11-29

    .PARAMETER TaskName
    Name of the task to be disabled.

    .PARAMETER TaskPath
    Path to a scheduled tasks folder. All tasks in the specified path will be disabled.

    .EXAMPLE
    Set-ScheduledTaskDisabled
    Uses the default list of tasks to be disabled.

    #>

    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    Param(
        [Parameter()]
        [string[]]$TaskName,
        [string[]]$TaskPath,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    begin {
        $SplatLogEntry = @{
            Tee     = $Tee
            WhatIf  = $WhatIfPreference
        }
        $AllScheduledTasks = Get-ScheduledTask
    }

    process {
        # Disable Task by Name
        foreach ($Name in $TaskName) {
            if (($AllScheduledTasks.TaskName) -contains $Name) {
                if ($PSCmdlet.ShouldProcess("$Name")) {
                    Write-Progress -Activity "Disabling Tasks (By Name)" -Status "Processing $Name" -PercentComplete (($TaskName.IndexOf($Name) + 1) / $TaskName.Count * 100)
                    try {
                        Get-ScheduledTask -TaskName $Name | Disable-ScheduledTask -ErrorAction Stop | Out-Null
                        Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: DisableScheduledTasks: Name - Disabled: $Name"
                    }
                    catch {
                        Write-LogEntry @SplatLogEntry -LogLevel ERROR -LogMessage "HardenSystem: DisableScheduledTasks: Name - Failed to disable: $Name. Error: $_"
                    }
                }
            }
            else {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: DisableScheduledTasks: Name - Does not exist: $Name"
            }
        }

        # Disable Task by Path
        foreach ($Path in $TaskPath) {
            if (($AllScheduledTasks.TaskPath) -contains $Path) {
                if ($PSCmdlet.ShouldProcess("$Path")) {
                    Write-Progress -Activity "Disabling Tasks (By Path)" -Status "Processing $Path" -PercentComplete (($TaskPath.IndexOf($Path) + 1) / $TaskPath.Count * 100)
                    try {
                        Get-ScheduledTask -TaskPath $Path | Disable-ScheduledTask -ErrorAction Stop | Out-Null
                        Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: DisableScheduledTasks: Path - Disabled: $Path"
                    }
                    catch {
                        Write-LogEntry @SplatLogEntry -LogLevel ERROR -LogMessage "HardenSystem: DisableScheduledTasks: Path - Failed to disable: $Path. Error: $_"
                    }
                }
            }
            else {
                Write-LogEntry @SplatLogEntry -LogMessage "HardenSystem: DisableScheduledTasks: Path - Does not exist: $Path"
            }
        }
    }

    end {}
}