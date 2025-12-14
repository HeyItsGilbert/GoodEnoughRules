function Get-CommandParameter {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [System.Management.Automation.Language.CommandAst]
        $Command
    )

    $commandElements = $Command.CommandElements
    Write-Verbose "Processing command: $($Command.GetCommandName())"
    Write-Verbose "Total command elements: $($commandElements.Count - 1)"
    #region Gather Parameters
    # Create a hash to hold the parameter name as the key, and the value
    $parameterHash = @{}
    # Track positional parameter index
    $positionalIndex = 0
    # Start at index 1 to skip the command name
    for ($i = 1; $i -lt $commandElements.Count; $i++) {
        Write-Debug $commandElements[$i]
        # Switch on type
        switch ($commandElements[$i].GetType().Name) {
            'ParameterAst' {
                $parameterName = $commandElements[$i].ParameterName
                # Next element is the value
                continue
            }
            'CommandParameterAst' {
                $parameterName = $commandElements[$i].ParameterName
                # Initialize to $true for switch parameters
                $parameterHash[$parameterName] = $true
                continue
            }
            'StringConstantExpressionAst' {
                $value = $commandElements[$i].Value
                # Check if a parameter name was set
                if (-not $parameterName) {
                    Write-Verbose "Positional parameter or argument detected: $value"
                    $parameterHash["PositionalParameter$positionalIndex"] = $value
                    $positionalIndex++
                    continue
                }
                $parameterHash[$parameterName] = $value
                continue
            }
            default {
                Write-Verbose "Unhandled command element type: $($commandElements[$i].GetType().Name)"
                # Grab the string from the extent
                $value = $commandElements[$i].SafeGetValue()
                $parameterHash[$parameterName] = $value
            }
        }
    }
    return $parameterHash
}
