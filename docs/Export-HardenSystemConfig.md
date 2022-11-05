---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Export-HardenSystemConfig

## SYNOPSIS
Saves a configuration file that can be used with the function: Invoke-HardenSystem.

## SYNTAX

```
Export-HardenSystemConfig [[-ApplyGPO] <Hashtable[]>] [[-DEP] <String>] [-DisablePoshV2]
 [[-DisableScheduledTask] <Hashtable[]>] [[-DisableService] <String[]>] [[-EnableLog] <String[]>]
 [-LocalUserPasswordExpires] [[-Mitigation] <String[]>] [[-RemoveWinApp] <String[]>] [-FilePath] <String>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script accepts input for the same parameters as can be used with 'Invoke-HardenSystem'.
The inputs are then saved as a JSON configuration file.
This configuration can then be imported using 'Import-HardenSystemConfig'.

Specify the parameters the same as you would for 'Invoke-HardenSystem'.
For parameters that are included within the configuration file, see 'Invoke-HardenSystem' for details.

## EXAMPLES

### EXAMPLE 1
```
$ApplyGPO = @{OS = 'Win10'; Netbanner = 'Test'; Office = '2016'; Defender = $true; AppLocker = 'Audit'}
```

PS C:\\\>Export-HardenSystemConfig -ApplyGPO $ApplyGPO -Path "C:\Temp\Custom.json"
Config file saved to: C:\temp\Custom.json

The first line creates a hash table of the GPOs that should be applied.
The second line uses the $ApplyGPO hash table with the 'ApplyGPO' parameter while also passing a path for the location of the outputted configuration file.
The configuration file is saved to 'C:\Temp\Custom.json'.

### EXAMPLE 2
```
$ApplyGPO = @{OS = 'Win10'; IE11 = $true; Chrome =$true; Firewall = $true; Defender = $true; AppLocker = 'Audit'; DisplayLogonInfo = $true}
```

PS C:\\\>$DisableService = 'ALG','AJRouter','BTAGService','bthserv','BthHFserv','DiagTrack','dmwappushservice','Fax','FrameServer','icssvc','lfsvc','lltdsvc','MapsBroker','MSiSCSI','NcbService','PhoneSvc','QWAVE','RetailDemo','RemoteAccess','RMSvc','SharedAccess','SSDPSRV','TapiSrv','WalletService','WFDSConMgrSvc','wlidsvc','WMPNetworkSvc','workfolderssvc','WpcMonSvc','xbgm','XblAuthmanager','XblGameSave','XboxGipSvc','XboxNetApiSvc'

PS C:\\\>$EnableLog = 'Microsoft-Windows-PrintService/Operational', 'Microsoft-Windows-TaskScheduler/Operational'

PS C:\\\>$RemoveWinApp = "Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Microsoft3DViewer", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MixedReality.Portal", "Microsoft.Office.OneNote", "Microsoft.OneConnect", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.StorePurchaseApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo"

PS C:\\\>$TaskName = "Adobe Acrobat Update Task", "Consolidator", "OneDrive Standalone Update Task v2", "XblGameSaveTask"

PS C:\\\>$TaskPath = "\Microsoft\Windows\Bluetooth\"

PS C:\\\>$DisableScheduledTask = @{TaskName = $TaskName; TaskPath = $TaskPath}

PS C:\\\>Export-HardenSystemConfig -ApplyGPO $ApplyGPO -DEP OptOut -DisablePoshV2 -DisableScheduledTask $DisableScheduledTask -DisableService $DisableService -EnableLog $EnableLog -LocalUserPasswordExpires -Mitigation RC4, SpeculativeExecution, SSL3Server, TLS1Server, TLS11Server, TripleDES -RemoveWinApp $RemoveWinApp -FilePath .\Default.json
This set of commands creates the 'Default.json' file included with this module.

## PARAMETERS

### -ApplyGPO
{{ Fill ApplyGPO Description }}

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DEP
{{ Fill DEP Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisablePoshV2
{{ Fill DisablePoshV2 Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableScheduledTask
{{ Fill DisableScheduledTask Description }}

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableService
{{ Fill DisableService Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnableLog
{{ Fill EnableLog Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LocalUserPasswordExpires
{{ Fill LocalUserPasswordExpires Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mitigation
{{ Fill Mitigation Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoveWinApp
{{ Fill RemoveWinApp Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FilePath
Specify the output location for the generated configuration file.
If only a directory is specified, the filename will be automatically generated (HardenSystemConfig-yyyyMMdd.json).
If the path specified does not exist, it will be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Name         - Export-HardenSystemConfig
Version      - 0.5
Author       - Darren Hollinrake
Date Created - 2021-07-24
Date Updated - 2021-08-31

## RELATED LINKS
