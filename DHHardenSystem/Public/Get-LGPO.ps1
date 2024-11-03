function Get-LGPO {
    <#
    .SYNOPSIS
    Downloads the LGPO tool from Microsoft.

    .DESCRIPTION
    This function will download the LGPO file from Microsoft. Once downloaded, it will be extracted and placed in the location specified by the 'LGPOPath' variable. For this function to work, it must be ran from an Internet-connected system.

    .NOTES
    Name         - Get-LGPO
    Version      - 1.0
    Author       - Darren Hollinrake
    Date Created - 2024-09-28
    Date Updated - 

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
                Write-LogEntry -Tee:$Tee -LogMessage "Downloading LGPO executable"
                Invoke-WebRequest -Uri $LGPOUrl -OutFile "$env:TEMP\LGPO.zip"
            }
            catch {
                Write-Error "Failed to download LGPO.zip. Error: $_" -ErrorAction Stop
            }

            try {
                Write-LogEntry -Tee:$Tee -LogMessage "Extracting files..."
                Expand-Archive -Path "$env:TEMP\LGPO.zip" -DestinationPath $env:TEMP
                Move-Item -Path "$env:TEMP\LGPO_30\LGPO.exe" -Destination $LGPOPath
            }
            catch {
                Write-LogEntry -LogLevel ERROR -Tee:$Tee -LogMessage "Failed to extract LGPO.zip. Error: $_" -ErrorAction
            }
            finally {
                Write-LogEntry -Tee:$Tee -LogMessage "Cleaning up..."
                Remove-Item -Path "$env:TEMP\LGPO.zip"
                Remove-Item -Path "$env:TEMP\LGPO_30" -Recurse
            }
        }
        else {
            Write-LogEntry -Tee:$Tee -LogMessage "The LGPO executable already exists. Nothing to do."
        }
        Write-LogEntry -Tee:$Tee -LogMessage "The executable is located here: $LGPOExe"
    }

    end { Write-LogEntry -StopLog -Tee:$Tee }
}