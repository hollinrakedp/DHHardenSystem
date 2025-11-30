function Enable-EventLog {
    <#
    .SYNOPSIS
    This script will enable the specified event logs.

    .NOTES
    Name        : Enable-EventLog
    Author      : Darren Hollinrake
    Version     : 2.2
    DateCreated : 2018-08-15
    DateUpdated : 2025-11-29

    .DESCRIPTION
    This script will enable the Windows event log for each log name provided.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]$LogName,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    begin {
        $Logs = Get-WinEvent -ListLog $LogName
    }
    process {
        foreach ($Log in $Logs) {
            try {
                if ($PSCmdlet.ShouldProcess("$($Log.LogName)")) {
                    if ($Log.IsEnabled) {
                        Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: EnableLog: Log Name: $($Log.LogName) - Already Enabled, Skipping..."
                    }
                    else {
                        Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: EnableLog: Log Name: $($Log.LogName) - Enabling"
                        $Log.set_IsEnabled($true)
                        $Log.SaveChanges()
                    }
                }
            }
            catch {
                Write-LogEntry -Tee:$Tee -LogLevel ERROR -LogMessage "HardenSystem: EnableLog: Log Name: $($Log.LogName) Error: $_"
            }
        }
    }
    end { }
}