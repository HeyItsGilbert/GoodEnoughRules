---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-InvokeWebRequestWithoutBasic

## SYNOPSIS
Rule to detect if Invoke-WebRequest is used without UseBasicParsing.

## SYNTAX

```
Measure-InvokeWebRequestWithoutBasic [-ScriptBlockAst] <ScriptBlockAst> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This rule detects if Invoke-WebRequest (or its aliases) is used without the
UseBasicParsing parameter.

## EXAMPLES

### EXAMPLE 1
```
Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ScriptBlockAst
```

This will check if the given ScriptBlockAst contains any Invoke-WebRequest
commands without the UseBasicParsing parameter.

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

## RELATED LINKS
