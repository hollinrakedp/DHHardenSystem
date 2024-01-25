function Set-ServiceDisabled {
    <#
    .SYNOPSIS
    Sets the startup type of specified services to 'Disabled'.

    .DESCRIPTION
    This function is designed to set the startup type to disabled of the specified services.


    .NOTES
    Name       : Set-ServiceDisabled
    Author     : Darren Hollinrake
    Version    : 1.1.1
    DateCreated: 2018-02-20
    DateUpdated: 2021-08-31

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
        $ServiceDisabled = @()
        $ServiceAlreadyDisabled = @()
        $ServiceNotExist = @()
    }

    process {
        foreach ($NamedService in $Name) {
            $ServiceObj = Get-Service -Name $NamedService -ErrorAction SilentlyContinue
            if ($ServiceObj) {
                if ($ServiceObj | Where-Object { $_.StartType -ne 'Disabled' }) {
                    if ($PSCmdlet.ShouldProcess("$NamedService", "Set-ServiceDisabled")) {
                        $ServiceObj | Stop-Service -PassThru | Set-Service -StartupType Disabled
                        $ServiceDisabled += $NamedService
                    }
                }
                else {
                    Write-LogEntry -Tee:$Tee -LogMessage "Service is already disabled: $NamedService"
                    $ServiceAlreadyDisabled += $NamedService
                }
            }
            else {
                Write-LogEntry -Tee:$Tee -LogMessage "The following service did not exist: $NamedService"
                $ServiceNotExist += $NamedService
            }
        }
    }

    end {
        # Report which services were modified
        Write-LogEntry -Tee:$Tee -LogMessage "Disabled the following service(s): $($ServiceDisabled -join ', ')"
        Write-LogEntry -Tee:$Tee -LogMessage "The following service(s) were already disabled: $($ServiceAlreadyDisabled -join ', ')"
        Write-LogEntry -Tee:$Tee -LogMessage "The following service(s) did not exist: $($ServiceNotExist -join ', ')"
    }
}