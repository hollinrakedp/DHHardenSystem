function Remove-WinApp {
    <#
    .SYNOPSIS
    Remove UWP Apps from the system.

    .DESCRIPTION
    Removes the supplied list of Universal Windows Platform (UWP) applications from the system.

    .NOTES
    Name       : Remove-WinApp
    Author     : Darren Hollinrake
    Version    : 0.9
    DateCreated: 2018-02-20
    DateUpdated: 2021-07-25

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$App
    )

    ForEach ($AppName in $App) {
        $PackageFullName = (Get-AppxPackage $AppName).PackageFullName
        $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object { $_.Displayname -eq $AppName }).PackageName
 
        if ($PackageFullName) {
            if ($PSCmdlet.ShouldProcess("$PackageFullName", "Remove-AppxPackage")) {
                Write-Verbose "Removing Package: $AppName"
                Remove-AppxPackage -Package $PackageFullName
            }
        }
 
        else {
            Write-Verbose "Unable To Find Package: $AppName"
        }
 
        if ($ProPackageFullName) {
            if ($PSCmdlet.ShouldProcess("$ProPackageFullName", "Remove-AppxProvisionedPackage")) {
                Write-Verbose "Removing Provisioned Package: $ProPackageFullName"
                Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName
            }
        }
 
        else {
            Write-Verbose "Unable To Find Provisioned Package: $AppName"
        }
    }
}