function Export-LocalGPO {
    <#
    .SYNOPSIS
    Exports a backup of the local group policy configuration.

    .DESCRIPTION
    This function will export the current configuration applied by the Local Group Policy on the system it is run on. This requires the LGPO tool to be added to your PATH.

    .NOTES
    Name         - Export-LocalGPO
    Version      - 0.1
    Author       - Darren Hollinrake
    Date Created - 2022-08-01
    Date Updated - 

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