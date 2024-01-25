function Write-LogEntry {
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
                    New-Item -Path $LogFullPath -Force -ItemType File | Out-Null
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