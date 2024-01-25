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
    Version     : 1.0
    DateCreated : 2018-08-02
    DateUpdated : 2024-01-20

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
        [string[]]$TaskName = @("Adobe Acrobat Update Task", "Consolidator", "OneDrive Standalone Update Task v2", "XblGameSaveTask"),
        [string[]]$TaskPath = @("\Microsoft\Windows\Bluetooth\"),
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
        Write-LogEntry @SplatLogEntry -LogMessage "Disable Scheduled Task: Task Name: Count: $($TaskName.Count)"
        foreach ($Name in $TaskName) {
            if (($AllScheduledTasks.TaskName) -contains $Name) {
                if ($PSCmdlet.ShouldProcess("$Name")) {
                    Write-Progress -Activity "Disabling Tasks (By Name)" -Status "Processing $Name" -PercentComplete (($TaskName.IndexOf($Name) + 1) / $TaskName.Count * 100)
                    Get-ScheduledTask -TaskName $Name | Disable-ScheduledTask
                    Write-LogEntry @SplatLogEntry -LogMessage "Disable Scheduled Task: Task Name: $Name - Task Disabled"
                }
            }
            else {
                Write-LogEntry @SplatLogEntry -LogMessage "Disable Scheduled Task: Task Name: $Name - Does Not Exists"
            }
        }

        # Disable Task by Path
        Write-LogEntry @SplatLogEntry -LogMessage "Disable Scheduled Task: Task Path: Count: $($TaskPath.Count)"
        foreach ($Path in $TaskPath) {
            if (($AllScheduledTasks.TaskPath) -contains $Path) {
                if ($PSCmdlet.ShouldProcess("$Path")) {
                    Write-Progress -Activity "Disabling Tasks (By Path)" -Status "Processing $Path" -PercentComplete (($TaskPath.IndexOf($Path) + 1) / $TaskPath.Count * 100)
                    Get-ScheduledTask -TaskPath $Path | Disable-ScheduledTask
                    Write-LogEntry @SplatLogEntry -LogMessage "Disable Scheduled Task: Task Path: $Path - Path Disabled"
                }
            }
            else {
                Write-LogEntry @SplatLogEntry -LogMessage "Scheduled Task: Task Path: $Path - Does Not Exists"
            }
        }
    }

    end {}
}