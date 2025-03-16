function Measure-SecureStringWithKey {
    <#
    .SYNOPSIS
    Rule to detect if ConvertFrom-SecureString is used without a Key.
    .DESCRIPTION
    This rule detects if ConvertFrom-SecureString is used without a Key which
    means the secret is user and machine bound.
    .EXAMPLE
    Measure-SecureStringWithKey -ScriptBlockAst $ScriptBlockAst

    This will check if the given ScriptBlockAst contains any
    ConvertFrom-SecureString commands without a Key parameter.
    .PARAMETER ScriptBlockAst
    The scriptblock AST to check.
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
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    Begin {
        $predicate = {
            param($Ast)
            $Ast -is [System.Management.Automation.Language.CommandAst] -and
            $Ast.GetCommandName() -eq 'ConvertFrom-SecureString'
        }
    }

    Process {
        [System.Management.Automation.Language.Ast[]]$commands = $ScriptBlockAst.FindAll($predicate, $true)
        $commands | ForEach-Object {
            $command = $_
            $parameterHash = Get-CommandParameters -Command $command
            if (-not $parameterHash.ContainsKey('Key')) {
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message = 'ConvertFrom-SecureString should be used with a Key.'
                    Extent = $command.Extent
                    Severity = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Severity]::Error
                }
            }
        }
    }
}
