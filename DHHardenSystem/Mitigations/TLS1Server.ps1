function TLS1Server {
    <#
    .SYNOPSIS
    Disables TLS 1.0 for the server in the SCHANNEL settings.

    .NOTES
    Name         - TLS1Server
    Version      - 1.3
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2025-11-29

    .DESCRIPTION
    This function disables TLS 1.0 for the server by setting the 'Enabled' registry property to 0 and 'DisabledByDefault' to 1 in the SCHANNEL settings.

    .EXAMPLE
    TLS1Server
    This command disables TLS 1.0 for the server in the SCHANNEL settings.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TLS 1.0 Server - Begin"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'

    if (!(Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }

    $KeyProperties = @(
        @{
            Name = 'Enabled'
            Value = 0
        },
        @{
            Name = 'DisabledByDefault'
            Value = 1
        }
    )
    
    foreach ($KeyProperty in $KeyProperties) {
        $ItemProperty = @{
            Path = $RegPath
            Name = $KeyProperty.Name
            Value = $KeyProperty.Value
            PropertyType = 'DWORD'
            Force = $true
        }
        if ($PSCmdlet.ShouldProcess("$RegPath::$($KeyProperty.Name)", 'Set registry value')) {
            Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TLS 1.0 Server - Setting $($KeyProperty.Name)=$($KeyProperty.Value)"
            New-ItemProperty @ItemProperty | Out-Null
        }
    }

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TLS 1.0 Server - Complete"
}