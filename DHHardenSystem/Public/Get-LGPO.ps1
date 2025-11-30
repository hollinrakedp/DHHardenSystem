function Get-LGPO {
    <#
    .SYNOPSIS
    Downloads the LGPO tool from Microsoft.

    .DESCRIPTION
    This function will download the LGPO file from Microsoft. Once downloaded, it will be extracted and placed in the location specified by the 'LGPOPath' variable. For this function to work, it must be ran from an Internet-connected system.

    .NOTES
    Name         - Get-LGPO
    Version      - 1.1
    Author       - Darren Hollinrake
    Date Created - 2024-09-28
    Date Updated - 2025-

    .PARAMETER LGPOPath
    Defines the location where the LGPO executable will be placed. By default, it will go into the module's 'LGPO' folder.

    .PARAMETER Tee
    Indicates that the output should be sent to the console and saved to the log file.

    .EXAMPLE
    Get-LGPO
    Downloading LGPO executable
    Extracting files

    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [Alias('Path')]
        [string]$LGPOPath = $Script:LGPOPath,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$Tee
    )

    begin { Write-LogEntry -StartLog -Tee:$Tee }

    process {
        $LGPOUrl = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
        $LGPOExe = Join-Path -Path $LGPOPath -ChildPath "LGPO.exe"

        if ( ! (Test-Path -Path $LGPOExe)) {
            try {
                Write-LogEntry -Tee:$Tee -LogMessage "LGPO: Download - LGPO"
                Invoke-WebRequest -Uri $LGPOUrl -OutFile "$env:TEMP\LGPO.zip"
            }
            catch {
                Write-Error "Failed to download LGPO.zip. Error: $_" -ErrorAction Stop
            }

            try {
                Write-LogEntry -Tee:$Tee -LogMessage "LGPO: Extract - Begin"
                Expand-Archive -Path "$env:TEMP\LGPO.zip" -DestinationPath $env:TEMP
                Move-Item -Path "$env:TEMP\LGPO_30\LGPO.exe" -Destination $LGPOPath
            }
            catch {
                Write-LogEntry -LogLevel ERROR -Tee:$Tee -LogMessage "LGPO: Extract - Failed: $_" -ErrorAction
            }
            finally {
                Write-LogEntry -Tee:$Tee -LogMessage "LGPO: Extract - Cleanup"
                Remove-Item -Path "$env:TEMP\LGPO.zip"
                Remove-Item -Path "$env:TEMP\LGPO_30" -Recurse
            }
        }
        else {
            Write-LogEntry -Tee:$Tee -LogMessage "LGPO: Download - LGPO already exists"
        }
        Write-LogEntry -Tee:$Tee -LogMessage "LGPO: Path - $LGPOExe"
    }

    end { Write-LogEntry -StopLog -Tee:$Tee }
}