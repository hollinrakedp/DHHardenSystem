---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version:
schema: 2.0.0
---

# Clear-LocalGroupPolicy

## SYNOPSIS
Clears local Group Policy configurations for user and/or computer settings.

## SYNTAX

```
Clear-LocalGroupPolicy [-RemoveUserSettings] [-RemoveComputerSettings] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes Local Group Policy settings on the current system. You can specify whether to remove user settings, computer settings, or both. The removal of settings is irreversible; use caution.

## EXAMPLES

### EXAMPLE 1
```
Clear-LocalGroupPolicy -RemoveComputerSettings -Confirm:$false
```
Removes computer-scoped settings without prompting.

### EXAMPLE 2
```
Clear-LocalGroupPolicy -RemoveUserSettings -RemoveComputerSettings -WhatIf
```
Shows what would happen if both user and computer settings were removed.

### EXAMPLE 3
```
Clear-LocalGroupPolicy -RemoveUserSettings
```
Removes only user-scoped settings.

## PARAMETERS

### -RemoveUserSettings
Indicates that user settings should be cleared from the local Group Policy.

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

### -RemoveComputerSettings
Indicates that computer settings should be cleared from the local Group Policy.

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
Name         - Clear-LocalGroupPolicy
Version      - 1.1
Author       - Darren Hollinrake
Date Created - 2024-09-28
Date Updated - 2024-10-22

Performs `gpupdate /force` after changes are made.

## RELATED LINKS
