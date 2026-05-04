function Measure-GremlinCharacter {
    <#
    .SYNOPSIS
    Rule to detect invisible or visually deceptive Unicode characters (gremlins).
    .DESCRIPTION
    This rule detects Unicode characters that are invisible or visually similar to
    legitimate characters, such as zero-width spaces, bidirectional overrides, and
    curly quotes. These characters can introduce subtle bugs or security issues that
    are nearly impossible to see in an editor.
    .EXAMPLE
    Measure-GremlinCharacter -Token $Token

    This will check if the given Token contains any gremlin characters.
    .PARAMETER Token
    The token to check for gremlin characters.
    .INPUTS
    [System.Management.Automation.Language.Token[]]
    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
    Inspired by https://github.com/nhoizey/vscode-gremlins
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.Token[]]
        $Token
    )

    begin {
        # Maps Unicode char to description + PSScriptAnalyzer severity
        $script:gremlins = [ordered]@{
            [char]0x0003 = @{ Description = 'end of text'; Severity = 'Warning' }
            [char]0x000B = @{ Description = 'line tabulation'; Severity = 'Warning' }
            [char]0x00A0 = @{ Description = 'non-breaking space'; Severity = 'Information' }
            [char]0x00AD = @{ Description = 'soft hyphen'; Severity = 'Information' }
            [char]0x200B = @{ Description = 'zero width space'; Severity = 'Error' }
            [char]0x200C = @{ Description = 'zero width non-joiner'; Severity = 'Warning' }
            [char]0x200E = @{ Description = 'left-to-right mark'; Severity = 'Error' }
            [char]0x2013 = @{ Description = 'en dash'; Severity = 'Warning' }
            [char]0x2018 = @{ Description = 'left single quotation mark'; Severity = 'Warning' }
            [char]0x2019 = @{ Description = 'right single quotation mark'; Severity = 'Warning' }
            [char]0x201C = @{ Description = 'left double quotation mark'; Severity = 'Warning' }
            [char]0x201D = @{ Description = 'right double quotation mark'; Severity = 'Warning' }
            [char]0x2029 = @{ Description = 'paragraph separator'; Severity = 'Error' }
            [char]0x2066 = @{ Description = 'left-to-right isolate'; Severity = 'Error' }
            [char]0x2069 = @{ Description = 'pop directional isolate'; Severity = 'Error' }
            [char]0x202C = @{ Description = 'pop directional formatting'; Severity = 'Error' }
            [char]0x202D = @{ Description = 'left-to-right override'; Severity = 'Error' }
            [char]0x202E = @{ Description = 'right-to-left override'; Severity = 'Error' }
            [char]0xFFFC = @{ Description = 'object replacement character'; Severity = 'Error' }
        }
    }

    process {
        foreach ($tok in $Token) {
            $text = $tok.Extent.Text

            foreach ($char in $script:gremlins.Keys) {
                if (-not $text.Contains($char)) {
                    continue
                }
                $info = $script:gremlins[$char]
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    'Message'  = "Gremlin character found: U+{0:X4} ({1}). This character may be invisible or visually deceptive." -f [int]$char, $info.Description
                    'Extent'   = $tok.Extent
                    'RuleName' = $PSCmdlet.MyInvocation.InvocationName
                    'Severity' = $info.Severity
                }
            }
        }
    }
}
