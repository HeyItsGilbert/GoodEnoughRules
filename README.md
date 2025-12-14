# GoodEnoughRules

A set of PSScriptAnalyzer rules that help make it Good Enough!

## Badges

| Downloads | Version | Publish Status | Supported Platforms |
|---|---|---|---|
| ![PowerShell Gallery][psgallery-downloads-badge] | ![PowerShell Gallery Version][psgallery-version-badge] | ![GitHub Workflow Status][build-badge] | ![PowerShell Gallery][platform-badge] |

## Overview

These are rules that _"Good Enough"_ Gilbert, slapped together after seeing
someone or something that wanted it. These may not be appropriate for the
standard set of rules so keep that in mind.

You will probably want to enable individual rules vs all of them at once. I
suggest taking a look at the documents to see what each rule does.

## Installation

Install from the [PowerShell Gallery][psgallery]:

```powershell
Install-PSResource GoodEnoughRules
```

## Documentation

The docs are automatically generated from the rule comment based help. You can see the docs at [HeyItsGilbert.GitHub.io/GoodEnoughRules](https://heyitsgilbert.github.io/GoodEnoughRules)

## Examples

### Running a Single Rule

```powershell
# Install and import
Install-PSResource GoodEnoughRules
$module = Import-Module GoodEnoughRules -PassThru
# Get the path the psm1
$modulePath = Join-Path $module.ModuleBase $module.RootModule
# Run against a folder
Invoke-ScriptAnalyzer -CustomRulePath $modulePath -IncludeRule 'Measure-InvokeWebRequestWithoutBasic' -Path '.\scripts\'
```

## Walk Through

> [!TIP]
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

## Using PSDepend

This module depends on `PSScriptAnalyzer` which means that it will install it
if's not available. If you have different required versions in your PSDepend
configuration that can cause conflict. I will try to avoid that by only
requiring a minimum version.

[psgallery-downloads-badge]: https://img.shields.io/powershellgallery/dt/goodenoughrules
[psgallery-version-badge]: https://img.shields.io/powershellgallery/v/GoodEnoughRules
[build-badge]: https://img.shields.io/github/actions/workflow/status/HeyItsGilbert/GoodEnoughRules/.github/workflows/publish.yaml?branch=main
[platform-badge]: https://img.shields.io/powershellgallery/p/GoodEnoughRules
[psgallery]: https://www.powershellgallery.com/packages/GoodEnoughRules
[sharing-custom-psscriptanalyzer-rules]: https://gilbertsanchez.com/posts/sharing-custom-psscriptanalyzer-rules/
