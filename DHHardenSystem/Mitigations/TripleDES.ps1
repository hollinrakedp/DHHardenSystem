function TripleDES{
    <#
    .SYNOPSIS
    Disables TripleDES Cipher.

    .NOTES
    Name         - TripleDES
    Version      - 1.2
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2025-11-29

    .DESCRIPTION
    This function disables the TripleDES cipher by setting the 'Enabled' registry property to 0 in the SCHANNEL settings.

    .EXAMPLE
    TripleDES
    This command disables the TripleDES cipher in the SCHANNEL settings.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TripleDES - Begin"
    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168'
        Name = 'Enabled'
        Value = 0
        PropertyType = 'DWORD'
        Force = $true
    }
    if ($PSCmdlet.ShouldProcess($ItemProperty['Path'], 'Disable TripleDES cipher')) {
        Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TripleDES - Disabling: $($ItemProperty['Path'])"
        if (!(Test-Path $ItemProperty['Path'])) {
            New-Item -Path $ItemProperty['Path'] -Force | Out-Null
        }
        New-ItemProperty @ItemProperty | Out-Null
    }

    Write-LogEntry -Tee:$Tee -LogMessage "HardenSystem: Mitigation: TripleDES - Complete"
}