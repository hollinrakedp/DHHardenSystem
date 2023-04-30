---
external help file: DHHardenSystem-help.xml
Module Name: DHHardenSystem
online version: https://public.cyber.mil/stigs/gpo/
schema: 2.0.0
---

# Invoke-LocalGPO

## SYNOPSIS
Applies GPOs against the local system.
The settings applied can be seen with the local group policy console (gpedit.msc).

## SYNTAX

```
Invoke-LocalGPO [-AcrobatProDC] [[-AppLocker] <String>] [-Chrome] [-Defender] [-DisplayLogonInfo] [-Edge]
 [-Firefox] [-IE11] [-Firewall] [[-NetBanner] <String>] [-NoPreviousUser] [[-Office] <String>] [-ReaderDC]
 [-RequireCtrlAltDel] [[-OS] <String>] [-Tee] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The 'Invoke-LocalGPO' function applies GPO's against the local system.
Many of the GPO's provided follow the DISA STIG GPO's and are labeled as 'DISA GPO' in the parameter help.
The additional Non-DISA GPO's provided are to configure some common settings or applied against Multi-User Stand Alone (MUSA) system.
GPO's are imported using Microsoft's LGPO tool (LGPO.exe).
The GPO's have been converted to '*.policyrules' text-based files.

The DISA GPOs included are based on the April 2023 GPO package.

Keep in mind the following:
 - For the GPOs that configure the OS, no check is made to ensure the GPO applied matches the installed OS.
 - For the GPO's that configure applications, no check is make to ensure the application is installed.
 - If the GPO has admx/adml files that are not included with the base installation of Windows, they will show up as extra registry settings when viewed from gpedit.msc
 - If the system is/will be joined to a domain, these local GPO's will not be processed if the following GPO setting is enabled:
      Computer Configuration \> Administrative Templates \> System \> Group Policy: Turn off Local Group Policy objects processing

## EXAMPLES

### EXAMPLE 1
```
Invoke-LocalGPO -OS Win10
```

Confirm
Are you sure you want to perform this action?
Performing the operation "Apply GPO" on target "OS: Win10".
\[Y\] Yes  \[A\] Yes to All  \[N\] No  \[L\] No to All  \[S\] Suspend  \[?\] Help (default is "Y"):

This example applies the Win10 STIG to the system.
Because the impact to the system is high, confirmation is required before each GPO will be applied.

### EXAMPLE 2
```
Invoke-LocalGPO -OS Win10 -IE11 -WhatIf
```

What if: Performing the operation "Apply GPO" on target "OS: Win10".
What if: Performing the operation "Apply GPO" on target "IE11: True".

This example makes use of the 'WhatIf' parameter to view the changes that would occur with the selected parameters.

### EXAMPLE 3
```
Invoke-LocalGPO -OS Win10 -IE11 -Confirm:$false
```

Applies the Win10 and IE11 STIGs to the system without prompting for confirmation.

## PARAMETERS

### -AcrobatProDC
DISA STIG (v2r1) - Configured Adobe Acrobat Pro (DC) in alignment with the corresponding DISA STIG.
This applies both User and Computer settings.

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

### -AppLocker
Custom - Configures AppLocker with a custom policy that allows users to run any Microsoft-signed programs AND any programs in the Program Files directories.
Administrators can run anything.
Valid values are 'Audit' and 'Enforce'.

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

### -Chrome
DISA STIG (v2r8) - Configures Google Chrome in alignment with the corresponding DISA STIG.
This applies Computer settings.

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

### -Defender
DISA STIG (v2r4) - Configures Windows Defender AV in alignment with the corresponding DISA STIG.
This applies Computer settings.

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

### -DisplayLogonInfo
Custom - After a user logs in successfully, displays the previous logon information (Last Logon Date, Failed logon attempts).

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

### -Edge
DISA STIG (v1r6) - Configures Edge (Chromium-based) in alignment with the corresponding DISA STIG.
This applies Computer settings.

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

### -Firefox
DISA STIG (v6r4) - Configures Firefox in alignment with the corresponding DISA STIG.
This applies Computer settings.

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

### -IE11
DISA STIG (v2r4) - Configures IE11 in alignment with the corresponding DISA STIG.
This applies both User and Computer settings.

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

### -Firewall
DISA STIG (v1r7) - Configures the Windows firewall in alignment with the corresponding DISA STIG.
This applies Computer settings.

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

### -NetBanner
Configures the Microsoft NetBanner application.
Valid values are 'FOUO', 'Secret', 'SecretNoForn', 'TopSecret', 'Unclass', and 'Test'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: NB

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoPreviousUser
Custom - Does not display the currently logged on user on the lock screen.

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

### -Office
DISA GPO - Configures MS Office using the specified Office STIG.
Valid values are '2016', and '2019'.
This applies both User and Computer settings.
Office 2016, the following STIGs are applied:
    Computer - Skype for Business 2016 - v1r1
    Computer - OneDrive for Business 2016 - v2r2
    Computer - Office System 2016 - v2r2
    User - Access 2016 - v1r1
    User - Excel 2016 - v1r2
    User - Office System 2016 - v2r1
    User - OneDrive for Business - v2r2
    User - Outlook 2016 - v2r3
    User - PowerPoint 2016 - v1r1
    User - Project 2016 - v1r1
    User - Publisher 2016 - v1r3
    User - Visio 2016 - v1r1
    User - Word 2016 - v1r1
Office 2019/365 (v2r8)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReaderDC
DISA STIG (v2r1) - Configures Reader DC (Continuous) in alignment with the corresponding DISA STIG.
This applies both User and Computer settings.

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

### -RequireCtrlAltDel
Custom - Configures the requirement for the user to press Ctrl + Alt + Del on the lock screen to bring up the login prompt.

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

### -OS
DISA GPO - Configures the OS using the specified OS STIG.
Valid values are 'Win10', 'Win11', 'Server2016', 'Server2019', and 'Server2022'.
This applies both User and Computer settings.
    Windows 10 - v2r6
    Windows 11 - v1r3
    Server 2016 - v2r6
    Server 2019 - v2r6
    Server 2022 - v1r2 (Computer Settings Only)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Name         - Invoke-LocalGPO
Version      - 1.1
Author       - Darren Hollinrake
Date Created - 2021-07-24
Date Updated - 2023-04-29

## RELATED LINKS

[https://public.cyber.mil/stigs/gpo/](https://public.cyber.mil/stigs/gpo/)

