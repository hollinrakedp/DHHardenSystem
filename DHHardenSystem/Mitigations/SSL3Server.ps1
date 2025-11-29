function SSL3Server {
    <#
    .SYNOPSIS
    Disables SSL 3.0 for the server in the SCHANNEL settings.

    .NOTES
    Name         - SSL3Server
    Version      - 1.2
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2025-11-28

    .DESCRIPTION
    This function disables SSL 3.0 for the server by setting the 'Enabled' registry property to 0 and 'DisabledByDefault' to 1 in the SCHANNEL settings.

    .EXAMPLE
    SSL3Server
    This command disables SSL 3.0 for the server in the SCHANNEL settings.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: SSL 3.0 Server - Begin"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server'

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
            Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: SSL 3.0 Server - Setting $($KeyProperty.Name)=$($KeyProperty.Value)"
            New-ItemProperty @ItemProperty | Out-Null
        }
    }

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: SSL 3.0 Server - Complete"
}