function Write-LogEntry {
    <#
    .SYNOPSIS
    Writes a time-stamped message to a log file.

    .DESCRIPTION
    This function adds more robust logging functionality for other scripts and functions. Each log entry is composed of three parts: timestamp, log level, and the message. The timestamp is in the following format: "yyyy-MM-dd HH:mm:ss:fff". There are three (3) log levels: ERROR, WARN, INFO. Each of these direct output to a corresponding stream as well as to the log. (ERROR to the Error stream, WARN to the Warning stream, INFO to the Verbose stream).

    Example Entry
    -------------
    2021-10-31 08:10:11:364 INFO: Writing an example to log.

    .NOTES
    Name       : Write-LogEntry
    Author     : Darren Hollinrake
    Version    : 1.2
    DateCreated: 2021-10-31
    DateUpdated: 2024-01-20


    .PARAMETER LogMessage
    This contains the message to be added to the log file. It should not include a timestamp or log level.

    .PARAMETER LogPath
    The path to the log file to which you would like to write. If this location does not exist, it will be created. If this parameter is not provided, a check is executed to see if the global scope or calling function/script has a $LogPath variable. If found, it will be used. If a value is still not found, the default value of 'C:\temp\Logs' will be used. The overall precedence order (from highest to lowest) is as follows: Directly specified, Calling function/script, Global scope, Default value.

    .PARAMETER LogFile
    The name of the log file to be used. If the file does not exist, it will be created. If it exists, new entries will be appended. If this parameter is not provided, a check is executed to see if the global scope or calling function/script has a $LogFile variable. If found, it will be used. If a value is still not found, the default value of 'PowerShell-yyyyMMdd.log' will be used.
    The overall precedence order (from highest to lowest) is as follows: Directly specified, Calling function/script, Global scope, Default value.

    .PARAMETER LogLevel
    Specify the level of the log message being written to the log (ERROR, WARN, INFO). If the parameter is not provided, the default value of 'INFO' will be used.

    .PARAMETER StartLog
    Writes an entry to the log indicating the start/beginning of the calling function or script. If neither of those can be found, it will assume it was called from an interactive session and show 'Interactive'.

    .PARAMETER StopLog
    Writes an entry to the log indicating the stop/end of the calling function or script. If a neither of those can be found, it will assume it was called from an interactive session and show 'Interactive'.

    .PARAMETER Tee
    Sends the output to both the host output and log file.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Log message'
    Writes the message provided to the default log path/file. Because the parameter LogLevel was not supplied, it will be use 'INFO'.

    Log Location
    ------------
    C:\Logs\PowerShell-20211031.log

    Log Entry
    ------------
    2021-10-31 08:13:12:864 INFO: Log message

    .EXAMPLE
    Write-LogEntry -LogMessage 'Log message' -Tee
    Same as the previous example but will also display the log entry to the console.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Restarting Server.' -Path C:\Logs\Scriptoutput.log
    Writes the specified log message to the log

    Log Location
    ------------
    C:\Logs\Scriptoutput.log

    Log Entry
    ------------
    2021-10-31 08:13:12:864 INFO: Restarting Server.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Folder does not exist.' -Path C:\Logs\ -Level Error
    Writes the message as an error message to the specified log path with the default filename (Powershell-yyyyMMdd.log). The message is also written to the error stream.

    Log Location
    ------------
    C:\Logs\PowerShell-20211031.log

    Log Entry
    ------------
    2021-10-31 08:15:52:127 ERROR: Folder does not exist.

    .EXAMPLE
    Write-LogEntry -StartLog
    Writes a message indicating the start of a script or function to the default log path/filename (C:\temp\Logs\PowerShell-yyyyMMdd.log)

    Log Location
    ------------
    C:\temp\Logs\PowerShell-20211031.log

    Log Entry
    ------------
    2021-10-31 08:15:52:674 INFO: ***** Start "My-FunctionName" *****

    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'LogMessage')]
    param (
        [Parameter(
            ParameterSetName = 'LogMessage',
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent,LogMsg")]
        [string]$LogMessage,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogPath = "C:\temp\Logs",

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogFile = "DHHardenSystem-$(Get-Date -Format yyyyMMdd).log",

        [Parameter(ParameterSetName = 'LogMessage',
            ValueFromPipelineByPropertyName)]
        [ValidateSet("ERROR", "WARN", "INFO")]
        [Alias('Level')]
        [string]$LogLevel = "INFO",

        [Parameter(ParameterSetName = 'StartLog')]
        [Alias('BeginLog')]
        [switch]$StartLog,

        [Parameter(ParameterSetName = 'StopLog')]
        [Alias('EndLog')]
        [switch]$StopLog,

        [Parameter()]
        [switch]$Tee
    )

    begin {
        if (!$PSBoundParameters.ContainsKey('ErrorAction')) {
            $ErrorActionPreference = $PSCmdlet.GetVariableValue('ErrorActionPreference')
        }
        if (!$PSBoundParameters.ContainsKey('VerbosePreference')) {
            $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        }
        if (!$PSBoundParameters.ContainsKey('LogFile')) {
            $CallingLogFile = $PSCmdlet.GetVariableValue('LogFile')
            if (![string]::IsNullOrEmpty($CallingLogFile)) {
                Write-Verbose "Using `$LogFile variable found in another scope"
                $LogFile = $CallingLogFile
            }
        }
        if (!$PSBoundParameters.ContainsKey('LogPath')) {
            $CallingLogPath = $PSCmdlet.GetVariableValue('LogPath')
            if (![string]::IsNullOrEmpty($CallingLogPath)) {
                Write-Verbose "Using `$LogFile variable found in another scope"
                $LogPath = $CallingLogPath
            }
        }
        $LogFullPath = Join-Path -Path $LogPath -ChildPath $LogFile
        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss:fff"
        # Determine the calling Function/Script name
        $CallingName = $(Get-PSCallStack)[1].FunctionName
        if ($CallingName -like "<ScriptBlock>*") {
            $CallingName = $(Get-PSCallStack)[1].Command
            if ($CallingName -like "<ScriptBlock>*") {
                $CallingName = "Interactive"
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'LogMessage' {
                Write-Verbose "Log File Location: $LogFullPath"
                if (!(Test-Path $LogFullPath)) {
                    Write-Verbose "Creating Log File"
                    New-Item -Path $LogFullPath -Force -ItemType File -WhatIf:$WhatIfPreference | Out-Null
                }
                $LogEntry = "$TimeStamp $($LogLevel.ToUpper())`: $LogMessage"
                $LogEntry | Add-Content -Path $LogFullPath
                if ($Tee) {
                    Write-Host $LogEntry
                }
                switch ($LogLevel) {
                    'ERROR' { Write-Error "$LogMessage" }
                    'WARN' { Write-Warning "$LogMessage" }
                    'INFO' { Write-Verbose "$LogMessage" }
                }
            }
            'StartLog' {
                $StartLogMessage = "***** Start `"$CallingName`" *****"
                Write-LogEntry -LogMessage "$StartLogMessage" -Tee:$Tee
            }
            'StopLog' {
                $StopLogMessage = "***** Stop `"$CallingName`" *****"
                Write-LogEntry -LogMessage "$StopLogMessage" -Tee:$Tee
            }
        }
    }

    end {}
}