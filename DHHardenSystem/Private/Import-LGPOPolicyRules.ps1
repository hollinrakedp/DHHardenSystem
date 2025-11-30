function Import-LGPOPolicyRules {
    <#
    .SYNOPSIS
    Imports a Policy Analyzer .PolicyRules file using LGPO.exe and returns a structured result.

    .DESCRIPTION
    Validates the .PolicyRules path, honors -WhatIf, conditionally checks for LGPO.exe,
    executes the import, captures exit status, and returns an object suitable for
    aggregated reporting.

    .NOTES
    Name         - Import-LGPOPolicyRules
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2025-11-12
    Date Updated - 2025-11-29

    .PARAMETER Name
    Optional friendly name for the policy being applied (e.g., 'Win11 (Computer)').
    If not supplied, the name is derived from the .PolicyRules filename.

    .PARAMETER PolicyRulesPath
    Full path to the .PolicyRules file to import.

    .PARAMETER LogFilePath
    Full path to the log file to append LGPO.exe verbose output to.

    .PARAMETER Tee
    When present, echoes key messages to host in addition to logging.

    .OUTPUTS
    PSCustomObject with fields:
    Name, PolicyRulesPath, Executed, WhatIf, ExitCode, Success, Status,
    Severity, Message, StartTime, EndTime, DurationMs, LogFile, LogTail

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PolicyRulesPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$LogFilePath,

        [switch]$Tee
    )

    $StartTime = Get-Date
    $Status = 'Unknown'
    $Severity = 'INFO'
    $Message = ''
    $ExitCode = $null
    $Executed = $false

    try {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            $Name = [System.IO.Path]::GetFileNameWithoutExtension($PolicyRulesPath)
        }
        if (-not (Test-Path -Path $PolicyRulesPath -PathType Leaf)) {
            $Status = 'NotFound'
            $Severity = 'WARN'
            $Message = "PolicyRules file not found: $PolicyRulesPath"
            Write-LogEntry -Tee:$Tee -LogLevel $Severity -LogMessage $("HardenSystem: GPO: LGPO:NotFound: {0} - {1}" -f $Name,$Message)

            return [pscustomobject]@{
                Name = $Name
                PolicyRulesPath = $PolicyRulesPath
                Executed = $false
                WhatIf = [bool]$WhatIfPreference
                ExitCode = $null
                Success = $false
                Status = $Status
                Severity = $Severity
                Message = $Message
                StartTime = $StartTime
                EndTime = Get-Date
                DurationMs = (New-TimeSpan -Start $StartTime -End (Get-Date)).TotalMilliseconds
                LogFile = $LogFilePath
                LogTail = $null
            }
        }

        if (-not $PSCmdlet.ShouldProcess($PolicyRulesPath, 'Import PolicyRules')) {
            $Status = 'Skipped'
            $Severity = 'INFO'
            $Message = 'WhatIf/Confirm: LGPO import not executed.'
            return [pscustomobject]@{
                Name = $Name
                PolicyRulesPath = $PolicyRulesPath
                Executed = $false
                WhatIf = [bool]$WhatIfPreference
                ExitCode = $null
                Success = $true
                Status = $Status
                Severity = $Severity
                Message = $Message
                StartTime = $StartTime
                EndTime = Get-Date
                DurationMs = (New-TimeSpan -Start $StartTime -End (Get-Date)).TotalMilliseconds
                LogFile = $LogFilePath
                LogTail = $null
            }
        }

        # Ensure log file exists
        $ParentPath = Split-Path -Path $LogFilePath -Parent
        if (-not (Test-Path -Path $ParentPath)) {
            New-Item -Path $ParentPath -ItemType Directory -Force | Out-Null
        }
        if (-not (Test-Path -Path $LogFilePath)) {
            New-Item -Path $LogFilePath -ItemType File -Force | Out-Null
        }

        Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: GPO: LGPO:PolicyRules: Apply - $Name"
        # Execute via cmd.exe so redirection happens in cmd (append, single handle)
        $cmd = 'cmd.exe'
        $Header = "----- LGPO BEGIN: $Name -----"
        & $cmd /c "echo $Header>> `"$LogFilePath`""
        $cmdArgs = @('/c', "LGPO.exe /p `"$PolicyRulesPath`" /v 1>> `"$LogFilePath`" 2>>&1")
        & $cmd @cmdArgs
        $Footer = "----- LGPO END:   $Name ExitCode=$LASTEXITCODE -----"
        & $cmd /c "echo $Footer>> `"$LogFilePath`""
        $Executed = $true
        $ExitCode = $LASTEXITCODE

        $RecentLog = @()
        try { $RecentLog = Get-Content -Path $LogFilePath -ErrorAction SilentlyContinue -Tail 100 } catch { }
        $RecentLogText = ($RecentLog -join "`n")
        $HasErrorText = $false
        $StepRegistry = $null
        $StepSecurity = $null
        $StepAudit = $null
        $SeceditExit = $null
        $AuditClearExit = $null
        $AuditRestoreExit = $null
        if ($RecentLogText) {
            $HasErrorText = ($RecentLogText -match '(?i)\b(error|failed|exception)\b')
            if ($RecentLogText -match '(?m)^POLICY SAVED\.') { $StepRegistry = 'Applied' } else { $StepRegistry = 'N/A' }
            if ($RecentLogText -match '(?m)^SECEDIT\.EXE exited with exit code (\d+)') {
                $SeceditExit = [int]$Matches[1]
                $SeceditWarn = ($RecentLogText -match '(?i)No mapping between account names and security IDs was done')
                if ($SeceditExit -eq 0) { $StepSecurity = 'Applied' }
                elseif ($SeceditExit -eq 1 -and $SeceditWarn) { $StepSecurity = 'AppliedWithWarning (SID mapping)' }
                else { $StepSecurity = "ExitCode=$SeceditExit" }
            }
            else {
                $StepSecurity = 'N/A'
            }
            $auditMatches = [System.Text.RegularExpressions.Regex]::Matches($RecentLogText, '(?m)^AUDITPOL\.EXE exited with exit code (\d+)')
            if ($auditMatches.Count -ge 1) { $AuditClearExit = [int]$auditMatches[0].Groups[1].Value }
            if ($auditMatches.Count -ge 2) { $AuditRestoreExit = [int]$auditMatches[1].Groups[1].Value }
            if ($null -ne $AuditClearExit -or $null -ne $AuditRestoreExit) {
                $StepAudit = "Clear=$AuditClearExit Restore=$AuditRestoreExit"
            }
            else {
                $StepAudit = 'N/A'
            }
        }

        if ($ExitCode -eq 0) {
            $Status = 'Success'
            $Severity = 'INFO'
            $Message = 'LGPO import completed successfully.'
        }
        elseif (-not $HasErrorText -and $ExitCode -eq 1) {
            # LGPO commonly returns 1 even when policy application succeeds; treat as informational when no error text is found
            $Status = 'Success'
            $Severity = 'INFO'
            $Message = "LGPO import completed (ExitCode 1) with no errors detected in log."
        }
        elseif (-not $HasErrorText) {
            $Status = 'Success'
            $Severity = 'WARN'
            $Message = "LGPO import likely succeeded (ExitCode $ExitCode, no errors detected in log)."
        }
        else {
            $Status = 'Failed'
            $Severity = 'ERROR'
            $Message = "LGPO.exe exited with code $ExitCode. See log for details."
        }

        $StepSummary = "Registry=$StepRegistry; Security=$StepSecurity; Audit=$StepAudit"
        Write-LogEntry -Tee:$Tee -LogLevel $Severity -LogMessage ("HardenSystem: GPO: LGPO:Result: {0} - Status={1} ExitCode={2} | {3}" -f $Name,$Status,$ExitCode,$StepSummary) -ErrorAction Continue
    }
    catch {
        $Status = 'Failed'
        $Severity = 'ERROR'
        $Message = "Exception during LGPO import: $($_.Exception.Message)"
        if (-not $ExitCode) { $ExitCode = $LASTEXITCODE }
    }
    finally {
        $EndTime = Get-Date
        $LogTail = $null
        try { $LogTail = Get-Content -Path $LogFilePath -ErrorAction SilentlyContinue -Tail 40 } catch { }
        [pscustomobject]@{
            Name = $Name
            PolicyRulesPath = $PolicyRulesPath
            Executed = $Executed
            WhatIf = [bool]$WhatIfPreference
            ExitCode = $ExitCode
            Success = ($Status -eq 'Success')
            Status = $Status
            Severity = $Severity
            Message = $Message
            StartTime = $StartTime
            EndTime = $EndTime
            DurationMs = (New-TimeSpan -Start $StartTime -End $EndTime).TotalMilliseconds
            LogFile = $LogFilePath
            LogTail = $LogTail -join "`n"
        }
    }
}
