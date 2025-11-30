---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Export-LocalGPO

## SYNOPSIS
Exports a backup of the local group policy configuration.

## SYNTAX

```
Export-LocalGPO [[-Path] <String>] [[-GPODisplayName] <String>] [-Tee] [<CommonParameters>]
```

## DESCRIPTION
This function will export the current configuration applied by the Local Group Policy on the system it is run on.
This requires the LGPO tool to be added to your PATH.

## EXAMPLES

### Example 1
```powershell
PS C:\> Export-LocalGPO -Path 'C:\Temp\LGPO-Backup' -GPODisplayName 'Baseline-2025'
```
Exports the Local Group Policy to the specified folder with a custom display name.

## PARAMETERS

### -Path
Destination folder to write the Local Group Policy backup.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -GPODisplayName
Optional display name to assign to the backup set. Defaults to computer name and date.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$env:ComputerName $(Get-Date -Format 'yyyyMMdd')"
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tee
Sends output to both host and log.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Name         - Export-LocalGPO
Version      - 0.1
Author       - Darren Hollinrake
Date Created - 2022-08-01
Date Updated - 2024-10-22

## RELATED LINKS
