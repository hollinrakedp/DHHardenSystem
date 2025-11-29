function TLS1Client {
    <#
    .SYNOPSIS
    Disables TLS 1.0 for the client in the SCHANNEL settings.

    .NOTES
    Name         - TLS1Client
    Version      - 1.2
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2025-11-28

    .DESCRIPTION
    This function disables TLS 1.0 for the client by setting the 'Enabled' registry property to 0 and 'DisabledByDefault' to 1 in the SCHANNEL settings.

    .EXAMPLE
    TLS1Client
    This command disables TLS 1.0 for the client in the SCHANNEL settings.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: TLS 1.0 Client - Begin"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'

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
            Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: TLS 1.0 Client - Setting $($KeyProperty.Name)=$($KeyProperty.Value)"
            New-ItemProperty @ItemProperty | Out-Null
        }
    }

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: TLS 1.0 Client - Complete"
}