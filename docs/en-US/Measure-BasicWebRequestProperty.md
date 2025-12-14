---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-BasicWebRequestProperty

## SYNOPSIS
Rule to detect if Invoke-WebRequest is used with UseBasicParsing and
incompatible properties.

## SYNTAX

```
Measure-BasicWebRequestProperty [-ScriptBlockAst] <ScriptBlockAst> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This rule detects if Invoke-WebRequest (or its aliases) is used with the
UseBasicParsing parameter and then attempts to access properties that are
incompatible with UseBasicParsing.
This includes properties like 'Forms',
'ParsedHtml', 'Scripts', and 'AllElements'.
This checks for both direct
member access after the command as well as variable assignments.

## EXAMPLES

### EXAMPLE 1
```
Measure-BasicWebRequestProperty -ScriptBlockAst $ScriptBlockAst
```

This will check if the given ScriptBlockAst contains any Invoke-WebRequest
commands with UseBasicParsing that access incompatible properties.

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
