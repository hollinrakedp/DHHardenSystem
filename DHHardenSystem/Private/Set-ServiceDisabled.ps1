function Set-ServiceDisabled {
    <#
    .SYNOPSIS
    Sets the startup type of specified services to 'Disabled'.

    .DESCRIPTION
    This function is designed to set the startup type to disabled of the specified services.


    .NOTES
    Name       : Set-ServiceDisabled
    Author     : Darren Hollinrake
    Version    : 1.2
    DateCreated: 2018-02-20
    DateUpdated: 2025-11-29

    .PARAMETER Name
    Specifies an array of service names for which the startup type should be set to 'Disabled'. This parameter is mandatory and can be taken from the pipeline by property name.

    .PARAMETER Tee
    Switch parameter that, when specified, enables logging to both the console and a log file.

    #>
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Mandatory)]
        [string[]]$Name,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    begin {
        $SplatLogEntry = @{
            Tee    = $Tee
            WhatIf = $WhatIfPreference
        }
    }

    process {
        foreach ($NamedService in $Name) {
            $ServiceObj = Get-Service -Name $NamedService -ErrorAction SilentlyContinue
            if ($ServiceObj) {
                if ($ServiceObj | Where-Object { $_.StartType -ne 'Disabled' }) {
                    if ($PSCmdlet.ShouldProcess("$NamedService", "Set-ServiceDisabled")) {
                        try {
                            $ServiceObj | Stop-Service -ErrorAction Stop
                            Write-LogEntry @SplatLogEntry -LogLevel INFO -LogMessage "Service: Stop: $NamedService - Success"
                        }
                        catch {
                            Write-LogEntry @SplatLogEntry -LogLevel WARN -LogMessage "Service: Stop: $NamedService - Failure"
                        }
                        try {
                            $ServiceObj | Set-Service -StartupType Disabled -ErrorAction Stop
                            Write-LogEntry @SplatLogEntry -LogMessage "Service: Disable: $NamedService - Success"
                        }
                        catch {
                            Write-LogEntry @SplatLogEntry -LogLevel ERROR -LogMessage "Service: Disable: $NamedService - Failure: $_"
                        }
                    }
                }
                else {
                    Write-LogEntry @SplatLogEntry -LogMessage "Service: Disable: $NamedService - Already Disabled"
                }
            }
            else {
                Write-LogEntry @SplatLogEntry -LogMessage "Service: Disable: $NamedService - Does Not Exist"
            }
        }
    }

    end {}
}