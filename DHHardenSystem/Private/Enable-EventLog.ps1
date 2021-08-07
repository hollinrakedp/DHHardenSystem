function Enable-EventLog {
    <#
    .SYNOPSIS
    This script will enable the specified event logs.

    .NOTES
    Name        : Enable-EventLog.ps1
    Author      : Darren Hollinrake
    Version     : 2.0
    DateCreated : 2018-08-15
    DateUpdated : 2021-07-23

    .DESCRIPTION
    This script will enable the Windows event log for each log name provided.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$LogName
    )
    begin {
        $GetLogs = { Get-WinEvent -ListLog $LogName }
        $Logs = & $GetLogs
    }
    process {
        foreach ($Log in $Logs) {
            if ($PSCmdlet.ShouldProcess("$($Log.LogName)")) {
                if ($Log.IsEnabled) {
                    Write-Verbose "The log `"$($Log.LogName)`" is already enabled."
                }
                else {
                    Write-Verbose "Enable Log: $($Log.LogName)"
                    $Log.set_IsEnabled($true)
                    $Log.SaveChanges()
                }
            }
        }
    }
    end { }
}