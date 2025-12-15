function Measure-BasicWebRequestProperty {
    <#
    .SYNOPSIS
    Rule to detect if Invoke-WebRequest is used with UseBasicParsing and
    incompatible properties.

    .DESCRIPTION
    This rule detects if Invoke-WebRequest (or its aliases) is used with the
    UseBasicParsing parameter and then attempts to access properties that are
    incompatible with UseBasicParsing. This includes properties like 'Forms',
    'ParsedHtml', 'Scripts', and 'AllElements'. This checks for both direct
    member access after the command as well as variable assignments.

    .PARAMETER ScriptBlockAst
    The scriptblock AST to check.

    .INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]

    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]

    .EXAMPLE
    Measure-BasicWebRequestProperty -ScriptBlockAst $ScriptBlockAst

    This will check if the given ScriptBlockAst contains any Invoke-WebRequest
    commands with UseBasicParsing that access incompatible properties.
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
        # We need to find any assignments or uses of Invoke-WebRequest (or its aliases)
        # to check if they attempt to use incompatible properties with UseBasicParsing.
        # Examples to find:
        # $bar = (iwr -Uri 'https://example.com' -UseBasicParsing).Forms
        $iwrMemberRead = {
            param($Ast)
            $Ast -is [System.Management.Automation.Language.CommandAst] -and
            # IWR Command
            $Ast.GetCommandName() -match '(Invoke-WebRequest|iwr|curl)' -and
            # With UseBasicParsing
            $Ast.CommandElements.ParameterName -contains 'UseBasicParsing' -and
            # That is being read as a member expression
            $Ast.Parent.Parent -is [System.Management.Automation.Language.ParenExpressionAst] -and
            $Ast.Parent.Parent.Parent -is [System.Management.Automation.Language.MemberExpressionAst] -and
            # The member being accessed is a string constant
            $Ast.Parent.Parent.Parent.Member -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
            # The member is one of the incompatible properties
            $incompatibleProperties -contains $Ast.Parent.Parent.Parent.Member
        }
        # Predicate to find assignments involving Invoke-WebRequest with UseBasicParsing
        # $foo = Invoke-WebRequest -Uri 'https://example.com' -UseBasicParsing
        $varAssignPredicate = {
            param($Ast)
            $Ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and
            $Ast.Right -is [System.Management.Automation.Language.PipelineAst] -and
            $Ast.Right.PipelineElements.Count -eq 1 -and
            $Ast.Right.PipelineElements[0] -is [System.Management.Automation.Language.CommandAst] -and
            $Ast.Right.PipelineElements[0].GetCommandName() -match '(Invoke-WebRequest|iwr|curl)' -and
            $Ast.Right.PipelineElements[0].CommandElements.ParameterName -contains 'UseBasicParsing'
        }
        $incompatibleProperties = @(
            'AllElements',
            'Forms',
            'ParsedHtml',
            'Scripts'
        )

    }

    process {
        # Find all member expression ASTs that match our criteria
        [System.Management.Automation.Language.Ast[]]$memberReads = $ScriptBlockAst.FindAll($iwrMemberRead, $false)
        foreach ($memberRead in $memberReads) {
            # ParenExpression would be the whole line: (iwr -Uri ... -UseBasicParsing).Foo
            $parenExpression = $memberRead.Parent.Parent
            $propertyName = $memberRead.Parent.Parent.Parent.Member.Value
            [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message = "Invoke-WebRequest cannot use the '$propertyName' parameter when 'UseBasicParsing' is specified."
                Extent = $parenExpression.Extent
                Severity = 'Error'
            }
        }
        # Find all assignment ASTs that match our criteria
        [System.Management.Automation.Language.Ast[]]$assignments = $ScriptBlockAst.FindAll($varAssignPredicate, $false)
        # Now use that to search for var reads of the assigned variable
        foreach ($assignment in $assignments) {
            $variableName = $assignment.Left.VariablePath.UserPath
            $lineAfter = $assignment.Extent.EndLineNumber
            Write-Verbose "Checking variable '$variableName' for incompatible property usage after line $lineAfter"
            # Find all reads of that variable
            #region Dynamically Build the AST Search Predicate
            $varReadPredicateScript = @()
            $varReadPredicateScript += 'param($Ast)'
            $varReadPredicateScript += '$Ast -is [System.Management.Automation.Language.VariableExpressionAst] -and'
            $varReadPredicateScript += '$Ast.VariablePath.UserPath -eq "' + $variableName + '" -and'
            $varReadPredicateScript += '$Ast.Extent.StartLineNumber -gt ' + $lineAfter
            $varReadPredicate = [scriptblock]::Create($($varReadPredicateScript -join "`n"))
            [System.Management.Automation.Language.Ast[]]$varReads = $ScriptBlockAst.FindAll($varReadPredicate, $true)
            foreach ($varRead in $varReads) {
                Write-Verbose "Found read of variable '$variableName' at line $($varRead.Extent.StartLineNumber)"
                if ($varRead.Parent -is [System.Management.Automation.Language.MemberExpressionAst]) {
                    $propertyName = $varRead.Parent.Member.Value
                    if ($incompatibleProperties -contains $propertyName) {
                        [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                            Message = "Invoke-WebRequest cannot use the '$propertyName' parameter when 'UseBasicParsing' is specified."
                            RuleName = $PSCmdlet.MyInvocation.InvocationName
                            Extent = $varRead.Parent.Extent
                            Severity = 'Error'
                        }
                    }
                }
            }
        }
    }
}
