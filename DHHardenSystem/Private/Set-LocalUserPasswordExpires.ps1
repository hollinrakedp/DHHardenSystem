function Set-LocalUserPasswordExpires {
    <#
    .SYNOPSIS
    Set Local Accounts to have expiring passwords

    .DESCRIPTION
    Checks the system for enabled accounts with a password set to never expire. For any account found matching that criteria, the password is set to expire.

    .NOTES
    Name       : Set-LocalUserPasswordExpires
    Author     : Darren Hollinrake
    Version    : 1.0
    DateCreated: 2021-08-05
    DateUpdated: 

    #>
    [CmdletBinding(
        ConfirmImpact = 'High',
        SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )
    $Users = Get-LocalUser | Where-Object { ($_.Enabled -eq $true) -and ($null -eq $_.PasswordExpires) }
    
    foreach ($User in $Users) {
        if ($PSCmdlet.ShouldProcess("$User")) {
            Write-LogEntry -Tee:$Tee -LogMessage "Setting password to expire for user: $User"
            $User | Set-LocalUser -PasswordNeverExpires:$false
        }
    }
}