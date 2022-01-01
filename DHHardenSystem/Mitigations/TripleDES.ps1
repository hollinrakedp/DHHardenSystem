function TripleDES{
    <#
    .SYNOPSIS
    Disables TripleDES Cipher.

    .NOTES
    Name         - TripleDES
    Version      - 1.0
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2021-10-11

    #>

    Write-Verbose "TripleDES"
    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168'
        Name = 'Enabled'
        Value = 0
        PropertyType = 'DWORD'
        Force = $true
    }
    if (!(Test-Path $ItemProperty['Path'])) {
        New-Item -Path $ItemProperty['Path'] -Force | Out-Null
    }
    New-ItemProperty @ItemProperty | Out-Null
}