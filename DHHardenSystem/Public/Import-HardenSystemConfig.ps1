function Import-HardenSystemConfig {
    <#
    .SYNOPSIS
    Imports saved configuration files created by 'Export-HardenSystemConfig'.

    .DESCRIPTION
    This function imports configuration files that can be piped to 'Invoke-HardenSystem'.

    .NOTES
    Name         - Import-HardenSystemConfig
    Version      - 0.2
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2024-01-24

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
    try {
        if ((Test-Path $FilePath) -and ($FilePath -match '^*\.json')) {
            $HardenSystemConfigObj = Get-Content "$FilePath" -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        }
        else {
            Write-Warning "The specified path is not valid. Please provide a valid config file path to import."
            return
        }
        $HardenSystemConfigObj
    }
    catch {
        throw "Error during configuration file import: $_"
    }
}