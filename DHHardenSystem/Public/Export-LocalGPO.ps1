function Export-LocalGPO {
    <#
    .SYNOPSIS
    Exports the local Group Policy Object (GPO) settings to a specified path.

    .DESCRIPTION
    This function is designed to export the local Group Policy Object (GPO) settings to a specified path. It requires the LGPO tool to be added to your PATH.

    .NOTES
    Name         - Export-LocalGPO
    Version      - 0.1
    Author       - Darren Hollinrake
    Date Created - 2022-08-01
    Date Updated -

    .PARAMETER Path
    Specifies the path where the exported GPO settings will be saved.

    .PARAMETER GPODisplayName
    Specifies the display name for the exported GPO.

    .EXAMPLE
    Export-LocalGPO -Path "C:\GPOBackup"
    Exports the local GPO settings to the specified path "C:\GPOBackup" and uses the default display name which consists of the computer name and current date (yyyyMMdd)

    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Path,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$GPODisplayName = "$env:ComputerName $(Get-Date -Format 'yyyyMMdd')"
    )
    if (!(Get-Command lgpo.exe -ErrorAction SilentlyContinue)) {
        Write-Error "Unable to find 'LGPO.exe'. Ensure it has been downloaded and added to 'PATH'." -ErrorAction Stop
    }

    & LGPO.exe /b "$Path" /n "$GPODisplayName"
}