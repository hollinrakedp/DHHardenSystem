---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Get-LGPO

## SYNOPSIS
Downloads the LGPO tool from Microsoft and places `LGPO.exe` in the specified path.

## SYNTAX

```
Get-LGPO [[-LGPOPath] <String>] [-Tee] [<CommonParameters>]
```

## DESCRIPTION
Downloads the LGPO zip from Microsoft, extracts it, and moves `LGPO.exe` into the path provided by `-LGPOPath` (defaults to the module’s `LGPO` folder). Requires Internet access when `LGPO.exe` is not already present.

## EXAMPLES

### EXAMPLE 1
```
Get-LGPO
```
Downloads and extracts LGPO to the default module path if it is not present.

## PARAMETERS

### -LGPOPath
Defines the location where the LGPO executable will be placed. By default, it will go into the module's `LGPO` folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: False
Position: 1
Default value: Module LGPO folder
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tee
Indicates that the output should be sent to the console and saved to the log file.

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
Name         - Get-LGPO
Version      - 1.1
Author       - Darren Hollinrake
Date Created - 2024-09-28
Date Updated - 2025-

## RELATED LINKS

