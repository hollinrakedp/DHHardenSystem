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
    Version    : 2.0
    DateCreated: 2021-10-31
    DateUpdated: 2025-11-29


    .PARAMETER LogMessage
    This contains the message to be added to the log file. It should not include a timestamp or log level.

    .PARAMETER LogPath
    The path to the log file to which you would like to write. If this location does not exist, it will be created. If this parameter is not provided, a check is executed to see if the global scope or calling function/script has a $LogPath variable. If found, it will be used. If a value is still not found, the default value of 'C:\temp\Logs' will be used. The overall precedence order (from highest to lowest) is as follows: Directly specified, Calling function/script, Global scope, Default value.

    .PARAMETER LogFile
    The name of the log file to be used. If the file does not exist, it will be created. If it exists, new entries will be appended. If this parameter is not provided, a check is executed to see if the global scope or calling function/script has a $LogFile variable. If found, it will be used. If a value is still not found, the default value of 'DHHardenSystem-yyyyMMdd.log' will be used.
    The overall precedence order (from highest to lowest) is as follows: Directly specified, Calling function/script, Global scope, Default value.

    .PARAMETER LogLevel
    Specify the level of the log message being written to the log (ERROR, WARN, INFO). If the parameter is not provided, the default value of 'INFO' will be used.

    .PARAMETER StartLog
    Writes an entry to the log indicating the start/beginning of the calling function or script. If neither of those can be found, it will assume it was called from an interactive session and show 'Interactive'.

    .PARAMETER StopLog
    Writes an entry to the log indicating the stop/end of the calling function or script. If a neither of those can be found, it will assume it was called from an interactive session and show 'Interactive'.

    .PARAMETER TimeStampFormat
    Optional custom timestamp format for each log entry. Defaults to "yyyy-MM-dd HH:mm:ss:fff".

    .PARAMETER Encoding
    Text encoding used when writing to the log file. Accepts the same common values as Out-File: Unicode, BigEndianUnicode, UTF7, UTF8, UTF32, ASCII, Default, OEM. Defaults to UTF8.

    .PARAMETER MaxFileSizeMB
    Optional maximum log file size in megabytes. When the log file exceeds this size, it will be renamed with a timestamp suffix and a new log file will be created. If not specified, no rotation occurs.

    .PARAMETER MaxRotatedLogs
    Maximum number of rotated log files to keep. When this limit is exceeded, the oldest rotated files are deleted. Only applies when MaxFileSizeMB is specified. Defaults to 5.

    .PARAMETER Tee
    Sends the output to both the host output and log file.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Log message'
    Writes the message to the default log path/file. Because the parameter LogLevel was not supplied, it will use 'INFO'.

    Log Location
    ------------
    C:\temp\Logs\DHHardenSystem-20211031.log

    Log Entry
    ------------
    2021-10-31 08:13:12:864 INFO: Log message

    .EXAMPLE
    Write-LogEntry -LogMessage 'Log message' -Tee
    Same as the previous example but will also display the log entry to the console.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Restarting Server.' -LogPath C:\Logs -LogFile Scriptoutput.log
    Writes the specified log message to the specified log path and file.

    Log Location
    ------------
    C:\Logs\Scriptoutput.log

    Log Entry
    ------------
    2021-10-31 08:13:12:864 INFO: Restarting Server.

    .EXAMPLE
    Write-LogEntry -LogMessage 'Folder does not exist.' -LogPath C:\Logs\ -LogLevel ERROR
    Writes the message as an error to the specified log path with the default filename (DHHardenSystem-yyyyMMdd.log). The message is also written to the error stream.

    Log Location
    ------------
    C:\Logs\DHHardenSystem-20211031.log

    Log Entry
    ------------
    2021-10-31 08:15:52:127 ERROR: Folder does not exist.

    .EXAMPLE
    Write-LogEntry -StartLog
    Writes a message indicating the start of a script or function to the default log path/filename (C:\temp\Logs\DHHardenSystem-yyyyMMdd.log)

    Log Location
    ------------
    C:\temp\Logs\DHHardenSystem-20211031.log

    Log Entry
    ------------
    2021-10-31 08:15:52:674 INFO: ***** Start "My-FunctionName" *****

    .EXAMPLE
    Write-LogEntry -LogMessage 'Large log entry' -MaxFileSizeMB 10 -MaxRotatedLogs 3
    Writes a log message. If the log file is 10MB or larger, it will be rotated by renaming it with a timestamp suffix. Only the 3 most recent rotated files will be kept.

    Log Rotation Example
    --------------------
    If DHHardenSystem-20251115.log exceeds 10MB, it will be renamed to:
    DHHardenSystem-20251115_20251115-143022-456.log

    And a new DHHardenSystem-20251115.log file will be created.
    When more than 3 rotated files exist, the oldest ones are automatically deleted.

    .EXAMPLE
    # Demonstrates scope inheritance for LogPath/LogFile
    $Script:LogPath = 'D:\Logs'
    $Script:LogFile = "DHHardenSystem-$(Get-Date -Format yyyyMMdd).log"
    Write-LogEntry -LogMessage 'Using module-level log path/file'
    # Because LogPath/LogFile are set in the calling scope, they are used automatically.

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
        [Alias("LogContent","LogMsg")]
        [string]$LogMessage,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogPath = $Script:LogPath,

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

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TimeStampFormat = 'yyyy-MM-dd HH:mm:ss:fff',

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Unicode','BigEndianUnicode','UTF7','UTF8','UTF32','ASCII','Default','OEM')]
        [string]$Encoding = 'UTF8',

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxFileSizeMB,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxRotatedLogs = 5,

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
            if (![string]::IsNullOrWhiteSpace($CallingLogFile)) {
                Write-Debug "Using `$LogFile variable found in another scope"
                $LogFile = $CallingLogFile
            }
        }
        if (!$PSBoundParameters.ContainsKey('LogPath')) {
            $CallingLogPath = $PSCmdlet.GetVariableValue('LogPath')
            if (![string]::IsNullOrWhiteSpace($CallingLogPath)) {
                Write-Debug "Using `$LogPath variable found in another scope"
                $LogPath = $CallingLogPath
            }
        }
        if ([string]::IsNullOrWhiteSpace($LogPath)) {
            # Final fallback if no LogPath found via params, calling scope, or script scope
            $LogPath = 'C:\temp\Logs'
        }
        $LogFullPath = Join-Path -Path $LogPath -ChildPath $LogFile

        switch ($Encoding) {
            'Unicode'           { $EncodingObject = [System.Text.Encoding]::Unicode }
            'BigEndianUnicode'  { $EncodingObject = [System.Text.Encoding]::BigEndianUnicode }
            'UTF7'              { $EncodingObject = [System.Text.Encoding]::UTF7 }
            'UTF8'              { $EncodingObject = New-Object System.Text.UTF8Encoding($false) }
            'UTF32'             { $EncodingObject = [System.Text.Encoding]::UTF32 }
            'ASCII'             { $EncodingObject = [System.Text.Encoding]::ASCII }
            'Default'           { $EncodingObject = [System.Text.Encoding]::Default }
            'OEM'               { $EncodingObject = [System.Text.Encoding]::GetEncoding([System.Console]::OutputEncoding.CodePage) }
            default             { $EncodingObject = New-Object System.Text.UTF8Encoding($false) }
        }

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
                Write-Debug "Log File Location: $LogFullPath"
                # Ensure target directory exists
                $LogDirectory = Split-Path -Path $LogFullPath -Parent
                $CanWrite = $true
                if (-not [string]::IsNullOrWhiteSpace($LogDirectory) -and -not (Test-Path -LiteralPath $LogDirectory -PathType Container)) {
                    if ($PSCmdlet.ShouldProcess($LogDirectory, 'Create log directory')) {
                        Write-Verbose "Creating log directory: $LogDirectory"
                        New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
                    }
                    else {
                        $CanWrite = $false
                    }
                }
                # Create File
                $FileExists = Test-Path -LiteralPath $LogFullPath -PathType Leaf
                if (-not $FileExists) {
                    if ($PSCmdlet.ShouldProcess($LogFullPath, 'Create log file')) {
                        Write-Verbose "Creating log file: $LogFullPath"
                        New-Item -ItemType File -Path $LogFullPath -Force | Out-Null
                        $FileExists = $true
                    }
                    else {
                        $CanWrite = $false
                    }
                }

                # Check if rotation is needed
                if ($FileExists -and $PSBoundParameters.ContainsKey('MaxFileSizeMB')) {
                    $FileInfo = Get-Item -LiteralPath $LogFullPath -ErrorAction SilentlyContinue
                    if ($FileInfo -and ($FileInfo.Length / 1MB) -ge $MaxFileSizeMB) {
                        $RotateTimestamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
                        $BaseFileName = [System.IO.Path]::GetFileNameWithoutExtension($LogFullPath)
                        $Extension = [System.IO.Path]::GetExtension($LogFullPath)
                        $RotatedFileName = "${BaseFileName}_${RotateTimestamp}${Extension}"
                        $RotatedPath = Join-Path -Path $LogDirectory -ChildPath $RotatedFileName
                        
                        if ($PSCmdlet.ShouldProcess($LogFullPath, "Rotate log file to $RotatedFileName")) {
                            Write-Verbose "Rotating log file: $LogFullPath -> $RotatedFileName"
                            Move-Item -LiteralPath $LogFullPath -Destination $RotatedPath -Force
                            
                            # Clean up old rotated files if limit exceeded
                            $RotatedFilePattern = "${BaseFileName}_*${Extension}"
                            $ExistingRotated = Get-ChildItem -LiteralPath $LogDirectory -Filter $RotatedFilePattern -ErrorAction SilentlyContinue |
                                Sort-Object -Property LastWriteTime -Descending
                            
                            if ($ExistingRotated.Count -gt $MaxRotatedLogs) {
                                $FilesToDelete = $ExistingRotated | Select-Object -Skip $MaxRotatedLogs
                                foreach ($OldFile in $FilesToDelete) {
                                    Write-Verbose "Removing old rotated log: $($OldFile.Name)"
                                    Remove-Item -LiteralPath $OldFile.FullName -Force
                                }
                            }
                            
                            # Create new empty log file
                            New-Item -ItemType File -Path $LogFullPath -Force | Out-Null
                        }
                    }
                }

                $TimeStamp = Get-Date -Format $TimeStampFormat
                $LogEntry = "$TimeStamp $($LogLevel.ToUpper())`: $LogMessage"

                if ($CanWrite) {
                    try {
                        $FileStream = [System.IO.File]::Open($LogFullPath, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
                        $Writer = New-Object System.IO.StreamWriter($FileStream, $EncodingObject)
                        $Writer.WriteLine($LogEntry)
                    }
                    finally {
                        if ($Writer) { $Writer.Dispose() }
                        if ($FileStream) { $FileStream.Dispose() }
                    }
                }
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