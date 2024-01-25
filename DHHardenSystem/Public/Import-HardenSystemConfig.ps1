function Import-HardenSystemConfig {
    <#
    .SYNOPSIS
    Imports saved configuration files created by 'Export-HardenSystemConfig'.

    .DESCRIPTION
    This function imports configuration files that can be piped to 'Invoke-HardenSystem'.

    .NOTES
    Name         - Import-HardenSystemConfig
    Version      - 0.1
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2021-08-06

    .PARAMETER FilePath
    Provide the file path for the configuration file to import.

    .EXAMPLE
    Import-HardenSystemConfig -FilePath "C:\Path\To\Config.json"
    Imports the configuration file located at the specified path.

    .EXAMPLE
    Import-HardenSystemConfig -FilePath "C:\Path\To\Config.json" | Invoke-HardenSystem
    This will perform the hardening operations specified in the configuration file.

    #>
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipelineByPropertyName,
            Mandatory)]
        [Alias('Path')]
        [string]$FilePath
    )
    if ((Test-Path $FilePath) -and ($FilePath -match '^*\.json')) {
        $HardenSystemConfigObj = Get-Content "$FilePath" | ConvertFrom-Json
    }
    else {
        Write-Warning "The specified path is not valid. Please provide a valid config file path to import."
        return
    }
    $HardenSystemConfigObj
}