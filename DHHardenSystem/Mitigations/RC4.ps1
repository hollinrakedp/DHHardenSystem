function RC4 {
    <#
    .SYNOPSIS
    Disables RC4 ciphers in the SCHANNEL settings.

    .NOTES
    Name         - RC4
    Version      - 1.2
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2025-02-15
    
    .DESCRIPTION
    This function disables the RC4 128/128, RC4 56/128, and RC4 40/128 ciphers by setting the 'Enabled' registry property to 0 in the SCHANNEL settings.

    .EXAMPLE
    RC4
    This command disables the RC4 ciphers in the SCHANNEL settings.

    #>
    Write-Verbose "RC4"
    
    $RegPaths = @(
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128',
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128',
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128'
    )
    
    foreach ($RegPath in $RegPaths) {
        REG ADD "$RegPath" /v Enabled /t REG_DWORD /d 0 /f
    }
}