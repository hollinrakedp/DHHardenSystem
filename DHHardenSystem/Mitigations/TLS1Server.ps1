function TLS1Server{
    Write-Verbose "TLS1Server"
    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
        Name = 'Enabled'
        Value = 0
        PropertyType = 'DWORD'
        Force = $true
    }
    if (!(Test-Path $ItemProperty['Path'])) {
        New-Item -Path $ItemProperty['Path'] -Force | Out-Null
    }
    New-ItemProperty @ItemProperty | Out-Null

    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
        Name = 'DisabledByDefault'
        Value = 1
        PropertyType = 'DWORD'
        Force = $true
    }
    if (!(Test-Path $ItemProperty['Path'])) {
        New-Item -Path $ItemProperty['Path'] -Force | Out-Null
    }
    New-ItemProperty @ItemProperty | Out-Null
}