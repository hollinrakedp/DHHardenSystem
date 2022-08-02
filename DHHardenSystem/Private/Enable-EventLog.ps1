function Enable-EventLog {
    <#
    .SYNOPSIS
    This script will enable the specified event logs.

    .NOTES
    Name        : Enable-EventLog
    Author      : Darren Hollinrake
    Version     : 2.0
    DateCreated : 2018-08-15
    DateUpdated : 2021-08-12

    .DESCRIPTION
    This script will enable the Windows event log for each log name provided.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$LogName,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    begin {
        $Logs = Get-WinEvent -ListLog $LogName
    }
    process {
        foreach ($Log in $Logs) {
            if ($PSCmdlet.ShouldProcess("$($Log.LogName)")) {
                if ($Log.IsEnabled) {
                    Write-LogEntry -Tee:$Tee -LogMessage "The log `"$($Log.LogName)`" is already enabled."
                }
                else {
                    Write-LogEntry -Tee:$Tee -LogMessage "Enable Log: $($Log.LogName)"
                    $Log.set_IsEnabled($true)
                    $Log.SaveChanges()
                }
            }
        }
    }
    end { }
}