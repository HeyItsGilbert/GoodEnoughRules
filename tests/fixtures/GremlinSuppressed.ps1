function Test-Suppressed {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'GoodEnoughRules\Measure-GremlinCharacter',
        '',
        Scope = 'Function',
        Justification = 'We love gremlins and want to use them in our tests.'
    )]
    param()
    return '–hello'
}
