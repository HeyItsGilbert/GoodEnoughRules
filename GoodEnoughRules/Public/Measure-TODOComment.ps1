function Measure-TODOComment {
    <#
    .SYNOPSIS
    Rule to detect if TODO style comments are present.
    .DESCRIPTION
    This rule detects if TODO style comments are present in the given ScriptBlockAst.
    .EXAMPLE
    Measure-TODOComment -ScriptBlockAst $ScriptBlockAst

    This would check if the given ScriptBlockAst contains any TODO comments.
    .PARAMETER ScriptBlockAst
    The ScriptBlockAst to check for TODO comments.
    .INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
    None
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
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
        $results = @()
        try {
            #region Finds ASTs that match the predicates.
            $startingLine = $ScriptBlockAst.Extent.StartLineNumber
            foreach ($i in $ScriptBlockAst.Extent.Text) {
                $matches = $regEx.Matches($i)
                if ($matches.Count -ne 0) {
                    $matches | ForEach-Object {
                        $result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                            'Message' = "TODO comment found. Please consider removing it or tracking with issue."
                            'Extent' = $ScriptBlockAst.Extent
                            'RuleName' = $PSCmdlet.MyInvocation.InvocationName
                            'Severity' = 'Information'
                        }
                        $results += $result
                    }
                }
                # Increment the line number
                $startingLine++
            }
            return $results
            #endregion
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
