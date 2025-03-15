@{
    CustomRulePath = @(
        '.\tests\PSScriptAnalyzerRules.psm1'
    )

    IncludeDefaultRules = $true

    IncludeRules = @(
        'PS*', # Include all the default rules
        # Custom rules
        'Measure-*'
    )
}
