function Get-CommandParameters {
    param (
        [System.Management.Automation.Language.CommandAst]
        $Command
    )

    $commandElements = $CommandAst.CommandElements
    #region Gather Parameters
    # Create a hash to hold the parameter name as the key, and the value
    $parameterHash = @{}
    for($i=1; $i -lt $commandElements.Count; $i++){
        # Switch on type
        switch ($commandElements[$i].GetType().Name){
            'CommandParameterAst' {
                $parameterName = $commandElements[$i].ParameterName
            }
            default {
                # Grab the string from the extent
                $value = $commandElements[$i].SafeGetValue()
                $parameterHash[$parameterName] = $value
            }
        }
    }
    return $parameterHash
}
