function SSL3Client {
    <#
    .SYNOPSIS
    Disables SSL 3.0 for the client in the SCHANNEL settings.

    .NOTES
    Name         - SSL3Client
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2024-10-22

    .DESCRIPTION
    This function disables SSL 3.0 for the client by setting the 'Enabled' registry property to 0 and 'DisabledByDefault' to 1 in the SCHANNEL settings.

    .EXAMPLE
    SSL3Client
    This command disables SSL 3.0 for the client in the SCHANNEL settings.

    #>
    Write-Verbose "SSL3Client"

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client'

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
            Name = $property.Name
            Value = $property.Value
            PropertyType = 'DWORD'
            Force = $true
        }
        
        New-ItemProperty @ItemProperty | Out-Null
    }
}