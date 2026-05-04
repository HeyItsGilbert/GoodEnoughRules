---
external help file: GoodEnoughRules-help.xml
Module Name: GoodEnoughRules
online version:
schema: 2.0.0
---

# Measure-GremlinCharacter

## SYNOPSIS
Rule to detect invisible or visually deceptive Unicode characters (gremlins).

## SYNTAX

```
Measure-GremlinCharacter [-Token] <Token[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This rule detects Unicode characters that are invisible or visually similar to
legitimate characters, such as zero-width spaces, bidirectional overrides, and
curly quotes. These characters can introduce subtle bugs or security issues that
are nearly impossible to see in an editor.

Severity levels reflect how dangerous the character is:

- **Error** - Bidirectional overrides, zero-width spaces, and control characters
  that can actively obscure code intent or enable Trojan-source attacks.
- **Warning** - Typographic characters (curly quotes, en dash) that are unlikely
  to be intentional in source code and may cause parse errors.
- **Information** - Characters like non-breaking spaces that are rarely intentional
  but generally harmless.

Inspired by the [vscode-gremlins](https://github.com/nhoizey/vscode-gremlins) extension.

## EXAMPLES

### EXAMPLE 1
```
Measure-GremlinCharacter -Token $Token
```

This will check if the given Token contains any gremlin characters.

## PARAMETERS

### -Token
The token to check for gremlin characters.

```yaml
Type: Token[]
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

### [System.Management.Automation.Language.Token]
## OUTPUTS

### [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
## NOTES
Inspired by https://github.com/nhoizey/vscode-gremlins

## RELATED LINKS
