function Measure-TODOComment {
    <#
    .SYNOPSIS
    Rule to detect if TODO style comments are present.
    .DESCRIPTION
    This rule detects if TODO style comments are present in the given ScriptBlockAst.
    .EXAMPLE
    Measure-TODOComment -ScriptBlockAst $ScriptBlockAst

    This will check if the given ScriptBlockAst contains any TODO comments.
    .PARAMETER Token
    The token to check for TODO comments.
    .INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
    None
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.Token]
        $Token
    )

    Begin {
        $toDoIndicators = @(
            'TODO',
            'FIXME',
            'BUG',
            'MARK',
            '\[.\]'
        ) -join '|'
        $regExOptions = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase #, IgnorePatternWhitespace, Multiline"
        # TODO: Add more comments to make it easier to understand the regular expression.
        # so meta hehe
        $regExPattern = "((\/\/|#|<!--|;|\*|^)((\s+(!|\?|\*|\-))?(\s+\[ \])?|(\s+(!|\?|\*)\s+\[.\])?)\s*($toDoIndicators)\s*\:?)"
        $regEx = [regex]::new($regExPattern, $regExOptions)
    }

    Process {
        if (-not $Token.Type -ne 'Comment') {
            return
        }
        #region Finds ASTs that match the predicates.
        foreach ($i in $Token.Extent.Text) {
            try {
                $matches = $regEx.Matches($i)
            }
            } catch {
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }
            if ($matches.Count -eq 0) {
                continue
            }
            $matches | ForEach-Object {
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    'Message' = "TODO comment found. Please consider removing it or tracking with issue."
                    'Extent' = $Token.Extent
                    'RuleName' = $PSCmdlet.MyInvocation.InvocationName
                    'Severity' = 'Information'
                }
            }
        }
        #endregion
    }
}
