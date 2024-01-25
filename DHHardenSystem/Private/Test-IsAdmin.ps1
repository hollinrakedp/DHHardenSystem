# UNCLASSIFIED
function Test-IsAdmin {
    <#
    .SYNOPSIS
    Checks if the current user is in an administrator role

    .DESCRIPTION
    Tests to see if the current user is is running with a privileged admin token. If they are, the return will be true, if not, the return will be false.

    .NOTES
    Name        : Test-IsAdmin
    Author      : Darren Hollinrake
    Version     : 1.0
    DateCreated : 2023-08-14
    DateUpdated : 

    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
}