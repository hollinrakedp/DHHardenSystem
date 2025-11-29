function RC4 {
    <#
    .SYNOPSIS
    Disables RC4 ciphers in the SCHANNEL settings.

    .NOTES
    Name         - RC4
    Version      - 1.3
    Author       - Darren Hollinrake
    Date Created - 2021-08-06
    Date Updated - 2025-11-28
    
    .DESCRIPTION
    This function disables the RC4 128/128, RC4 56/128, and RC4 40/128 ciphers by setting the 'Enabled' registry property to 0 in the SCHANNEL settings.

    .EXAMPLE
    RC4
    This command disables the RC4 ciphers in the SCHANNEL settings.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: RC4 - Begin"

    $RegPaths = @(
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128',
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128',
        'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128'
    )
    
    foreach ($RegPath in $RegPaths) {
        if ($PSCmdlet.ShouldProcess($RegPath, 'Disable RC4 cipher')) {
            Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: RC4 - Disabling: $RegPath"
            try {
                & REG ADD "$RegPath" /v Enabled /t REG_DWORD /d 0 /f | Out-Null
            }
            catch {
                Write-LogEntry -Tee:$Tee -LogLevel ERROR -LogMessage "Mitigation: RC4 - Failed to set Enabled=0 on $RegPath. Error: $_"
            }
        }
    }

    Write-LogEntry -Tee:$Tee -LogMessage "Mitigation: RC4 - Complete"
}