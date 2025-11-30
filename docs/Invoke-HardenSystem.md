---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Invoke-HardenSystem

## SYNOPSIS
Quickly hardens the local Windows installation system.

## SYNTAX

```
Invoke-HardenSystem [[-ApplyGPO] <Array>] [[-DEP] <String>] [-DisablePoShV2] [[-DisableScheduledTask] <Array>]
 [[-DisableService] <String[]>] [[-EnableLog] <String[]>] [-LocalUserPasswordExpires]
 [-Mitigation <String[]>] [[-RemoveWinApp] <String[]>] [-Tee] [-WhatIf] [-Confirm]
```

## DESCRIPTION
This function allows for quickly hardening the local Windows system.
Run the function without specifying any parameters to use the default hardening configuration which should be fine for most Windows 10 installations.

## EXAMPLES

### EXAMPLE 1
```
Invoke-HardenSystem -DEP OptOut
```
This example will set DEP on the system to 'OptOut'.

### EXAMPLE 2
```
Invoke-HardenSystem -ApplyGPO @{ OS = 'Win10'; IE11 = $true } -DEP OptOut -LocalUserPasswordExpires -WhatIf
```

What if: Performing the operation "Apply GPO" on target "OS: Win10".
What if: Performing the operation "Apply GPO" on target "IE11: True".
What if: Performing the operation "Set-DEP OptOut" on target "localhost".
What if: Performing the operation "Set-LocalUserPasswordExpires" on target "MyLocalUser".

This example makes use of the 'WhatIf' parameter to view the changes that would occur with the selected parameters.

### EXAMPLE 3
```
Invoke-HardenSystem -ApplyGPO @{ OS = 'Win11'; Defender = $true; CustomGPO = $true } -Confirm:$false
```

Applies selected built-in GPOs (Windows Defender, Windows 11 STIG) and then imports and applies any custom `.PolicyRules` files placed under `GPO\Custom` in the module. The `CustomGPO` flag is passed through to `Invoke-LocalGPO` automatically.

### EXAMPLE 4
```
Import-HardenSystemConfig .\Default.json | Invoke-HardenSystem -Confirm:$False
```

This example imports the configuration from the file 'Default.json' located in the current directory and passes the configuration to the 'Invoke-HardenSystem' function.
No confirmation is required before changes are made to the system.

## PARAMETERS

### -ApplyGPO
Applies settings against the Local Group Policy.
See 'Invoke-LocalGPO' for additional information on the parameters that can be called.

To import custom Policy Analyzer rules, include `CustomGPO = $true` in the hashtable passed to `-ApplyGPO`. This will call `Invoke-LocalGPO -CustomGPO`.

Example:

`-ApplyGPO @{ OS = 'Win11'; Chrome = $true; CustomGPO = $true }`

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DEP
Configures the Data Execution Prevention policy.
Valid values are 'OptIn', 'OptOut', 'AlwaysOn', 'AlwaysOff'.
Note: Changes to DEP require a reboot.

WARNING: This does not check to see if BitLocker is enabled on the system drive.
If it is, be sure to suspend BitLocker before rebooting or it will prompt for a recovery key.

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

### -DisablePoShV2
Remove the Windows Feature PowerShell v2 if it is installed.

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
Disables a user supplied list of scheduled tasks.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableService
Disables a user supplied list of services.
Provide the name of the service(s) (not the display name).

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
Enables the Windows event log for each log name provided.

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
Enables password expiration for any local accounts that are enabled and do not have a password expiration.

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
Enables the mitigation for the specified items.

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
Removes the supplied list of UWP Applications from the system.

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

### -Tee
Displays the log output to the console.

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
Name         - Invoke-HardenSystem
Version      - 1.1
Author       - Darren Hollinrake
Date Created - 2021-07-24
Date Updated - 2025-11-29

## RELATED LINKS
