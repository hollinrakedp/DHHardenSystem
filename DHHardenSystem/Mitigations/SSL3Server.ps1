function SSL3Server {
    <#
    .SYNOPSIS
    Disables SSL 3.0 for the server in the SCHANNEL settings.

    .NOTES
    Name         - SSL3Server
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2024-10-22

    .DESCRIPTION
    This function disables SSL 3.0 for the server by setting the 'Enabled' registry property to 0 and 'DisabledByDefault' to 1 in the SCHANNEL settings.

    .EXAMPLE
    SSL3Server
    This command disables SSL 3.0 for the server in the SCHANNEL settings.

    #>
    Write-Verbose "SSL3Server"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server'

    if (!(Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

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
        
        New-ItemProperty @ItemProperty | Out-Null
    }
}