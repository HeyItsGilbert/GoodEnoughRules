---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-TODOComment

## SYNOPSIS
Uses #Requires -RunAsAdministrator instead of your own methods.

## SYNTAX

```
Measure-TODOComment [-ScriptBlockAst] <ScriptBlockAst> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The #Requires statement prevents a script from running unless the Windows PowerShell
version, modules, snap-ins, and module and snap-in version prerequisites are met.
From Windows PowerShell 4.0, the #Requires statement let script developers require that
sessions be run with elevated user rights (run as Administrator).
Script developers does
not need to write their own methods any more.
To fix a violation of this rule, please
consider using #Requires -RunAsAdministrator instead of your own methods.

## EXAMPLES

### EXAMPLE 1
```
Measure-RequiresRunAsAdministrator -ScriptBlockAst $ScriptBlockAst
```

## PARAMETERS

### -ScriptBlockAst
{{ Fill ScriptBlockAst Description }}

```yaml
Type: ScriptBlockAst
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.Management.Automation.Language.ScriptBlockAst]
## OUTPUTS

### [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
## NOTES
None

## RELATED LINKS
