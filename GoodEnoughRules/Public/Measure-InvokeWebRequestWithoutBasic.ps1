function Measure-InvokeWebRequestWithoutBasic {
    <#
    .SYNOPSIS
    Rule to detect if Invoke-WebRequest is used without UseBasicParsing.

    .DESCRIPTION
    This rule detects if Invoke-WebRequest (or its aliases) is used without the
    UseBasicParsing parameter.

    .PARAMETER ScriptBlockAst
    The scriptblock AST to check.

    .INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]

    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]

    .EXAMPLE
    Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ScriptBlockAst

    This will check if the given ScriptBlockAst contains any Invoke-WebRequest
    commands without the UseBasicParsing parameter.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )
    begin {
        $predicate = {
            param($Ast)
            $Ast -is [System.Management.Automation.Language.CommandAst] -and
            $Ast.GetCommandName() -imatch '(Invoke-WebRequest|iwr|curl)$'
        }
    }

    process {
        [System.Management.Automation.Language.Ast[]]$commands = $ScriptBlockAst.FindAll($predicate, $true)
        $commands | ForEach-Object {
            Write-Verbose "Analyzing command: $($_.GetCommandName())"
            $command = $_
            $parameterHash = Get-CommandParameter -Command $command
            if (-not $parameterHash.ContainsKey('UseBasicParsing')) {
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message = 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
                    Extent = $command.Extent
                    RuleName = $PSCmdlet.MyInvocation.InvocationName
                    Severity = 'Error'
                }
            }
        }
    }
}
