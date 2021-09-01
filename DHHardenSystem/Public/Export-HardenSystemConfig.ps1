function Export-HardenSystemConfig {
    <#
    .SYNOPSIS
    Saves a configuration file that can be used with the function: Invoke-HardenSystem.

    .DESCRIPTION
    This script accepts input for the same parameters as can be used with 'Invoke-HardenSytem'. The inputs are then saved as a JSON configuration file. This configuration can then be imported using 'Import-HardenSystemConfig'.

    Specify the parameters the same as you would for 'Invoke-HardenSystem'. For parameters that are included within the configuration file, see 'Invoke-HardenSystem' for details.


    .NOTES
    Name         - Export-HardenSystemConfig
    Version      - 0.5
    Author       - Darren Hollinrake
    Date Created - 2021-07-24
    Date Updated - 2021-08-31

    .PARAMETER FilePath
    Specify the output location for the generated configuration file. If only a directory is specified, the filename will be automatically generated (HardenSystemConfig-yyyyMMdd.json). If the path specified does not exist, it will be created.

    .EXAMPLE
    $ApplyGPO = @{OS = 'Win10'; Netbanner = 'Test'; Office = '2016'; Defender = $true; AppLocker = 'Audit'}
    PS C:\>Export-HardenSystemConfig -ApplyGPO $ApplyGPO -Path "C:\Temp\Custom.json"
    Config file saved to: C:\temp\Custom.json

    The first line creates a hash table of the GPOs that should be applied. The second line uses the $ApplyGPO hash table with the 'ApplyGPO' parameter while also passing a path for the location of the outputted configuration file. The configuration file is saved to 'C:\Temp\Custom.json'.

    .EXAMPLE
    $ApplyGPO = @{OS = 'Win10'; IE11 = $true; Chrome =$true; Firewall = $true; Defender = $true; AppLocker = 'Audit'; DisplayLogonInfo = $true}
    PS C:\>$DisableService = 'ALG','AJRouter','BTAGService','bthserv','BthHFserv','DiagTrack','dmwappushservice','Fax','FrameServer','icssvc','lfsvc','lltdsvc','MapsBroker','MSiSCSI','NcbService','PhoneSvc','QWAVE','RetailDemo','RemoteAccess','RMSvc','SharedAccess','SSDPSRV','TapiSrv','WalletService','WFDSConMgrSvc','wlidsvc','WMPNetworkSvc','workfolderssvc','WpcMonSvc','xbgm','XblAuthmanager','XblGameSave','XboxGipSvc','XboxNetApiSvc'
    
    PS C:\>$EnableLog = 'Microsoft-Windows-PrintService/Operational', 'Microsoft-Windows-TaskScheduler/Operational'
    
    PS C:\>$RemoveWinApp = "Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Microsoft3DViewer", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MixedReality.Portal", "Microsoft.Office.OneNote", "Microsoft.OneConnect", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.StorePurchaseApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo"

    PS C:\>$TaskName = "Adobe Acrobat Update Task", "Consolidator", "OneDrive Standalone Update Task v2", "XblGameSaveTask"

    PS C:\>$TaskPath = "\Microsoft\Windows\Bluetooth\"

    PS C:\>$DisableScheduledTask = @{TaskName = $TaskName; TaskPath = $TaskPath}

    PS C:\>Export-HardenSystemConfig -ApplyGPO $ApplyGPO -DEP OptOut -DisablePoshV2 -DisableScheduledTask $DisableScheduledTask -DisableService $DisableService -EnableLog $EnableLog -LocalUserPasswordExpires -Mitigation RC4, SpeculativeExecution, SSL3Server, TLS1Server, TripleDES -RemoveWinApp $RemoveWinApp -FilePath .\Default.json
    This set of commands creates the 'Default.json' file included with this module.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [hashtable[]]$ApplyGPO,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('AlwaysOff', 'AlwaysOn', 'OptIn', 'OptOut')]
        [string]$DEP,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$DisablePoshV2,
        [Parameter(ValueFromPipelineByPropertyName)]
        [hashtable[]]$DisableScheduledTask,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$DisableService,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$EnableLog,
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]$LocalUserPasswordExpires,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$Mitigation,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$RemoveWinApp,
        [Parameter(
            ValueFromPipelineByPropertyName,
            Mandatory)]
        [Alias('Path')]
        [string]$FilePath
    )

    $Hashtable = @{}
    switch ($PSBoundParameters.Keys) {
        ApplyGPO {
            $Hashtable += @{ ApplyGPO = $ApplyGPO }
        }
        DEP {
            $Hashtable += @{ DEP = $DEP }
        }
        DisablePoshV2 {
            $Hashtable += @{ DisablePoshV2 = $DisablePoshV2.IsPresent }
        }
        DisableScheduledTask {
            $Hashtable += @{ DisableScheduledTask = $DisableScheduledTask }
        }
        DisableService {
            $Hashtable += @{ DisableService = $DisableService }
        }
        EnableLog {
            $Hashtable += @{ EnableLog = $EnableLog }
        }
        LocalUserPasswordExpires {
            $Hashtable += @{ LocalUserPasswordExpires = $LocalUserPasswordExpires.IsPresent }
        }
        Mitigation {
            $Hashtable += @{ Mitigation = $Mitigation }
        }
        RemoveWinApp {
            $Hashtable += @{ RemoveWinApp = $RemoveWinApp }
        }
    }
    $Config = [PSCustomObject]$Hashtable

    $JSON = $Config | ConvertTo-Json -Depth 4

    if ((Test-Path -Path $FilePath -PathType Container)) {
        Write-Verbose "Only a directory was provided. Using automatic filename."
        $FullPath = Join-Path -Path $FilePath -ChildPath "HardenSystemConfig-$(Get-Date -Format yyyyMMdd).json"
    }
    elseif ((Test-Path -Path $FilePath -IsValid) -and ($FilePath -match '^*\.json')) {
        Write-Verbose "A full path was provided."
        $FullPath = $FilePath
        $ParentPath = Split-Path $FilePath
        if (!(Test-Path "$ParentPath")) {
            if ($PSCmdlet.ShouldProcess("$ParentPath", "New-Item")) {
                Write-Verbose "Creating path: $ParentPath"
                New-Item -Path $ParentPath -Force -ItemType Directory | Out-Null
            }
        }
    }
    else {
        Write-Warning "The provided path is not valid. Please provide a valid path to a file or directory."
        return
    }
    if ($PSCmdlet.ShouldProcess("$FullPath", "Out-File")) {
        Write-Output "Config file saved to: $FullPath"
        $JSON | Out-File $FullPath | Out-Null
    }
}