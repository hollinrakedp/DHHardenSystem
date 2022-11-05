function Set-ServiceDisabled {
    <#
    .SYNOPSIS
    Stops and disables a service or list of services on the local system.

    .DESCRIPTION
    The script changes the startup type to "Disabled" for a list of services. Provide a custom list to the 'Name' parameter.

    .NOTES
    Name       : Set-ServiceDisabled
    Author     : Darren Hollinrake
    Version    : 1.1.1
    DateCreated: 2018-02-20
    DateUpdated: 2021-08-31

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