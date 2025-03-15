---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-TODOComment

## SYNOPSIS
Rule to detect if TODO style comments are present.

## SYNTAX

```
Measure-TODOComment [-Token] <Token> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This rule detects if TODO style comments are present in the given ScriptBlockAst.

## EXAMPLES

### EXAMPLE 1
```
Measure-TODOComment -ScriptBlockAst $ScriptBlockAst
```

This would check if the given ScriptBlockAst contains any TODO comments.

## PARAMETERS

### -Token
The token to check for TODO comments.

```yaml
Type: Token
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
