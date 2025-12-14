# GoodEnoughRules

A set of PSScriptAnalyzer rules that help make it Good Enough!

## Badges

| Downloads | Version | Publish Status | Supported Platforms |
|---|---|---|---|
| [![PowerShell Gallery][psgallery-downloads-badge]][psgallery] | [![PowerShell Gallery Version][psgallery-version-badge]][psgallery] | [![GitHub Workflow Status][build-badge]](https://github.com/HeyItsGilbert/GoodEnoughRules/actions/workflows/publish.yaml) | [![PowerShell Gallery][platform-badge]][psgallery] |

## Overview

These are rules that _"Good Enough"_ Gilbert, slapped together after seeing
someone or something that wanted it.  These may not be appropriate for your
environment so keep that in mind when including them.

You will probably want to enable individual rules vs all of them at once.  I
suggest taking a look at the documents to see what each rule does. 

## Installation

Install from the [PowerShell Gallery][psgallery]:

```powershell
Install-PSResource GoodEnoughRules
```

## Documentation

The docs are automatically generated from the rule comment based help. You can see the docs at [HeyItsGilbert.GitHub.io/GoodEnoughRules](https://heyitsgilbert.github.io/GoodEnoughRules)

## Available Rules

### Measure-TODOComment

**Severity:** Information

Detects TODO-style comments in your code, including TODO, FIXME, BUG, MARK, and checkbox-style comments (`[ ]`).

```powershell
# This will trigger the rule: 
# TODO:  Refactor this function
# FIXME: Handle edge case
```

**Why it matters:** Helps track pending work items and ensures technical debt is documented and addressable.

### Measure-InvokeWebRequestWithoutBasic

**Severity:** Error

Detects when `Invoke-WebRequest` (or its aliases `iwr`, `curl`) is used without the `UseBasicParsing` parameter.

```powershell
# This will trigger the rule: 
Invoke-WebRequest -Uri 'https://example.com'

# This is preferred: 
Invoke-WebRequest -Uri 'https://example.com' -UseBasicParsing
```

**Why it matters:** `UseBasicParsing` avoids dependency on Internet Explorer's DOM parser, making scripts more portable and reliable, especially in server environments.

### Measure-BasicWebRequestProperty

**Severity:** Error

Detects when `Invoke-WebRequest` is used with `UseBasicParsing` but then tries to access properties that are incompatible with basic parsing (like `Forms`, `ParsedHtml`, `Scripts`, `AllElements`).

```powershell
# This will trigger the rule:
$response = Invoke-WebRequest -Uri 'https://example.com' -UseBasicParsing
$forms = $response.Forms  # These properties aren't available with UseBasicParsing
```

**Why it matters:** Prevents runtime errors by catching incompatible property access at analysis time. 

### Measure-SecureStringWithKey

**Severity:** Error

Detects when `ConvertFrom-SecureString` is used without a `-Key` parameter, which means the encrypted string is bound to the specific user and machine.

```powershell
# This will trigger the rule:
$secureString | ConvertFrom-SecureString

# This is preferred for portability:
$secureString | ConvertFrom-SecureString -Key $keyBytes
```

**Why it matters:** Without a key, encrypted strings cannot be decrypted on different machines or by different users, limiting portability and automation scenarios.


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

