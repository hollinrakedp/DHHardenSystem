function TLS11Client{
    Write-Verbose "TLS1Client"
    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
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
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
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