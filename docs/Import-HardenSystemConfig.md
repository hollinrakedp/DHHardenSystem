---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Import-HardenSystemConfig

## SYNOPSIS
Imports saved configuration files created by 'Export-HardenSystemConfig'.

## SYNTAX

```
Import-HardenSystemConfig [-FilePath] <String> [<CommonParameters>]
```

## DESCRIPTION
This function imports configuration files that can be piped to 'Invoke-HardenSystem'.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -FilePath
Provide the file path for the configuration file to import.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Name         - Import-HardenSystemConfig
Version      - 0.1
Author       - Darren Hollinrake
Date Created - 2021-07-24
Date Updated - 2021-08-06

## RELATED LINKS
