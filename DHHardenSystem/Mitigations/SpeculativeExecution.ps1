function SpeculativeExecution{
    <#
    .SYNOPSIS
    Configures Speculative Execution mitigations.

    .NOTES
    Name         - SpeculativeExecution
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2021-12-31

    https://support.microsoft.com/en-us/help/4072698/windows-server-guidance-to-protect-against-the-speculative-execution

    #>

    Write-Verbose "SpeculativeExecution"
    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
        Name = 'FeatureSettingsOverride'
        Value = 72
        PropertyType = 'DWORD'
        Force = $true
    }
    if (!(Test-Path $ItemProperty['Path'])) {
        New-Item -Path $ItemProperty['Path'] -Force | Out-Null
    }
    New-ItemProperty @ItemProperty | Out-Null

    $ItemProperty =@{
        Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
        Name = 'FeatureSettingsOverrideMask'
        Value = 3
        PropertyType = 'DWORD'
        Force = $true
    }
    if (!(Test-Path $ItemProperty['Path'])) {
        New-Item -Path $ItemProperty['Path'] -Force | Out-Null
    }
    New-ItemProperty @ItemProperty | Out-Null
}
