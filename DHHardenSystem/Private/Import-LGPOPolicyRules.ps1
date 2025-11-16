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
    Version      - 1.0
    Author       - Darren Hollinrake
    Date Created - 2025-11-12
    Date Updated - 

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

        if ($Tee) { Write-Host "Importing PolicyRules: $Name" }
        & LGPO.exe /p "$PolicyRulesPath" /v >> "$LogFilePath"
        $Executed = $true
        $ExitCode = $LASTEXITCODE
        if ($ExitCode -eq 0) {
            $Status = 'Success'
            $Severity = 'INFO'
            $Message = 'LGPO import completed successfully.'
        }
        else {
            $Status = 'Failed'
            $Severity = 'ERROR'
            $Message = "LGPO.exe exited with code $ExitCode."
        }
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
