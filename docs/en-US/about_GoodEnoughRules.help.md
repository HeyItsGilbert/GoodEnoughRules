# GoodEnoughRules

## about_GoodEnoughRules

# SHORT DESCRIPTION
A set of PSScriptAnalyzer custom rules that help make your PowerShell code
"Good Enough" by detecting common issues and anti-patterns.

# LONG DESCRIPTION
GoodEnoughRules is a PowerShell module that provides custom rules for
PSScriptAnalyzer. These rules help identify code quality issues, security
concerns, and best practice violations in your PowerShell scripts.

The module includes rules for:

- Detecting insecure web request practices (Basic authentication)
- Identifying TODO comments in code
- Finding insecure SecureString usage with hardcoded keys
- Validating web request properties and parameters

These rules are designed to catch issues that may not be covered by the
standard PSScriptAnalyzer rules, helping you maintain better code quality
and security in your PowerShell projects.

## Available Rules

### Measure-BasicWebRequestProperty
Detects the use of Basic authentication in web request cmdlets, which can
expose credentials in plain text.

### Measure-InvokeWebRequestWithoutBasic
Identifies Invoke-WebRequest and Invoke-RestMethod calls that may be missing
proper authentication methods.

### Measure-SecureStringWithKey
Finds SecureString operations using hardcoded keys, which undermines the
security of SecureString.

### Measure-TODOComment
Locates TODO comments in your code to help track pending work items.

# EXAMPLES

## Example 1: Run a Single Rule

```powershell
# Install and import the module
Install-PSResource GoodEnoughRules
$module = Import-Module GoodEnoughRules -PassThru

# Get the path to the module
$modulePath = Join-Path $module.ModuleBase $module.RootModule

# Run a specific rule against a folder
Invoke-ScriptAnalyzer -CustomRulePath $modulePath `
    -IncludeRule 'Measure-InvokeWebRequestWithoutBasic' `
    -Path '.\scripts\'
```

## Example 2: Run All Rules

```powershell
# Import the module
Import-Module GoodEnoughRules
$module = Get-Module GoodEnoughRules
$modulePath = Join-Path $module.ModuleBase $module.RootModule

# Run all custom rules
Invoke-ScriptAnalyzer -CustomRulePath $modulePath -Path '.\MyScript.ps1'
```

## Example 3: Include in Settings File

Create a PSScriptAnalyzerSettings.psd1 file:

```powershell
@{
    CustomRulePath = @(
        'C:\Path\To\GoodEnoughRules\GoodEnoughRules.psm1'
    )
    IncludeRules = @(
        'Measure-BasicWebRequestProperty',
        'Measure-TODOComment'
    )
}
```

Then run:

```powershell
Invoke-ScriptAnalyzer -Path .\MyScript.ps1 -Settings .\PSScriptAnalyzerSettings.psd1
```

# NOTE

These rules are designed to catch specific patterns that may not be appropriate
for all projects. You should enable rules individually based on your project's
requirements rather than enabling all rules at once.

The rules in this module represent "Good Enough" practices - they help catch
common issues but may not be exhaustive or suitable for all scenarios.

For best results, use these rules in conjunction with the standard
PSScriptAnalyzer rules.

# TROUBLESHOOTING NOTE

## CustomRulePath Not Found

If you receive errors about the CustomRulePath not being found, ensure you're
using the full path to the .psm1 file:

```powershell
$module = Get-Module GoodEnoughRules
$modulePath = Join-Path $module.ModuleBase $module.RootModule
```

## Rules Not Running

Make sure to use the -IncludeRule parameter to explicitly enable the custom
rules you want to run, as they may not be enabled by default.

# SEE ALSO

- [Invoke-ScriptAnalyzer](https://docs.microsoft.com/en-us/powershell/module/psscriptanalyzer/invoke-scriptanalyzer)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
- [GoodEnoughRules Documentation](https://heyitsgilbert.github.io/GoodEnoughRules)
- [GoodEnoughRules GitHub Repository](https://github.com/HeyItsGilbert/GoodEnoughRules)
- Measure-BasicWebRequestProperty
- Measure-InvokeWebRequestWithoutBasic
- Measure-SecureStringWithKey
- Measure-TODOComment

# KEYWORDS

- PSScriptAnalyzer
- CustomRules
- CodeQuality
- StaticAnalysis
- ScriptAnalyzer
- SecurityRules
- BestPractices

