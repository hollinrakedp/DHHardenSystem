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
Export-LocalGPO [[-Path] <String>] [[-GPODisplayName] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will export the current configuration applied by the Local Group Policy on the system it is run on.
This requires the LGPO tool to be added to your PATH.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Path
{{ Fill Path Description }}

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
{{ Fill GPODisplayName Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Name         - Export-LocalGPO
Version      - 0.1
Author       - Darren Hollinrake
Date Created - 2022-08-01
Date Updated -

## RELATED LINKS
