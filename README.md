# GoodEnoughRules

A set of PSScriptAnalyzer rules that help make it Good Enough!

## Badges

[![PowerShell Gallery][psgallery-downloads-badge]
![PowerShell Gallery Version][psgallery-version-badge]
![GitHub Workflow Status][build-badge]
![PowerShell Gallery][platform-badge]][psgallery]

## Overview

These are rules that (Good Enough) Gilbert, slapped together after seeing
someone or something that wanted it. These may not be appropriate for the
standard set of rules so keep that in mind.

You will probably want to enable individual rules vs all of them.

## Installation

Install from the [PowerShell Gallery][psgallery]:

```powershell
Install-PSResource GoodEnoughRules
```

## Walk Through

> [!TIP] Tip
> Use a "proxy module" to load all your different custom rules and check that into your repository. This helps you avoid having to hardcode to a specific module path.

1. Install the module.
2. Create a custom rule file: `PSScriptAnalyzerRules.psm1`

    ```pwsh
    # Proxy Module example
    $rules = Import-Module -Name 'GoodEnoughRules' -PassThru
    Export-ModuleMember -Function @($rules.ExportedCommands.Keys)
    ```

3. Import it into your PSScriptAnalyzer config: `PSScriptAnalyzerSettings.psd1`

    ```pwsh
    @{
        CustomRulePath      = @(
            '.\PSScriptAnalyzerRules.psm1'
        )

        IncludeDefaultRules = $true

        IncludeRules        = @(
            # Default rules
            'PSAvoidDefaultValueForMandatoryParameter'
            'PSAvoidDefaultValueSwitchParameter'

            # Custom rules
            'Measure-*'
        )
    }
    ```

If you're interested in learning more about the "Proxy Module" concept, see
[Sharing Your Custom PSScriptAnalyzer Rules][sharing-custom-psscriptanalyzer-rules]

[psgallery-downloads-badge]: https://img.shields.io/powershellgallery/dt/goodenoughrules
[psgallery-version-badge]: https://img.shields.io/powershellgallery/v/GoodEnoughRules
[build-badge]: https://img.shields.io/github/actions/workflow/status/HeyItsGilbert/GoodEnoughRules/.github/workflows/CI.yaml?branch=main
[platform-badge]: https://img.shields.io/powershellgallery/p/GoodEnoughRules
[psgallery]: https://www.powershellgallery.com/packages/GoodEnoughRules
[sharing-custom-psscriptanalyzer-rules]: https://gilbertsanchez.com/posts/sharing-custom-psscriptanalyzer-rules/
