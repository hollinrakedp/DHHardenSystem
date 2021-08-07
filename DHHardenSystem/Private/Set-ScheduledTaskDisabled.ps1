function Set-ScheduledTaskDisabled {
    <#
    .SYNOPSIS
    Disables a list of scheudled tasks.

    .NOTES
    Name        : Set-ScheduledTaskDisabled
    Author      : Darren Hollinrake
    Version     : 0.8
    DateCreated : 2018-08-02
    DateUpdated : 2021-08-06

    .DESCRIPTION
    This script will disabled unnecessary scheduled tasks on the system it's ran. You can specify a list of task names, list of 
    task paths, or both.

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
        [string[]]$TaskPath = @("\Microsoft\Windows\Bluetooth\")
    )

    begin {
        $AllScheduledTasks = Get-ScheduledTask
    }

    process {
        #Disable Task by Name
        foreach ($Name in $TaskName) {
            If (($AllScheduledTasks.TaskName) -contains $Name) {
                if ($PSCmdlet.ShouldProcess("$Name")) {
                    Get-ScheduledTask -TaskName $Name | Disable-ScheduledTask
                }
            }
        }
        #Disable Task by Path
        Foreach ($Path in $TaskPath) {
            If (($AllScheduledTasks.TaskPath) -contains $Path) {
                if ($PSCmdlet.ShouldProcess("$Path")) {
                    Get-ScheduledTask -TaskPath $Path | Disable-ScheduledTask
                }
            }
        }
    }

    end {}
}