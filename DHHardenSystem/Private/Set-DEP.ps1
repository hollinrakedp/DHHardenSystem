Function Set-DEP {
    <#
    .SYNOPSIS
    Set the DEP policy of the system.

    .DESCRIPTION
    Configure the Data Exploit Protection policy on the system. This change requires a reboot to take effect.

    .NOTES
    Name       : Set-DEP
    Author     : Darren Hollinrake
    Version    : 0.3
    DateCreated: 2018-02-20
    DateUpdated: 2021-08-06

    .PARAMETER Policy
    The value used to set the Data Exploit Protection policy on the system.

    #>
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
    Param(
        [Parameter(
            ValueFromPipelineByPropertyName,
            ValueFromPipeline)]
        [ValidateSet('AlwaysOff', 'AlwaysOn', 'OptIn', 'OptOut')]
        [Alias("Value")]
        [string[]]$Policy,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    $SetValue = switch ($Policy) {
        AlwaysOff { 0 }
        AlwaysOn { 1 }
        OptIn { 2 }
        OptOut { 3 }
    }
    if ($PSCmdlet.ShouldProcess("localhost", "Set-DEP $Policy")) {
        $CurrentValue = (Get-CimInstance -ClassName Win32_OperatingSystem).DataExecutionPrevention_SupportPolicy
        Write-LogEntry -Tee:$Tee -LogMessage "DEP Current Value = $CurrentValue"

        if ($SetValue -eq $CurrentValue) {
            Write-Output "DEP is already set to $CurrentValue"
            return
        }
        Write-LogEntry -Tee:$Tee -LogMessage "Setting DEP to $Policy"
        BCDEDIT /set "{current}" nx $Policy
    }
}