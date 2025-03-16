---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-SecureStringWithKey

## SYNOPSIS
Rule to detect if ConvertFrom-SecureString is used without a Key.

## SYNTAX

```
Measure-SecureStringWithKey [-ScriptBlockAst] <ScriptBlockAst> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This rule detects if ConvertFrom-SecureString is used without a Key.

## EXAMPLES

### EXAMPLE 1
```
Measure-SecureStringWithKey -ScriptBlockAst $ScriptBlockAst
```

This will check if the given ScriptBlockAst contains any
ConvertFrom-SecureString commands without a Key parameter.

## PARAMETERS

### -ScriptBlockAst
The scriptblock AST to check.

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
