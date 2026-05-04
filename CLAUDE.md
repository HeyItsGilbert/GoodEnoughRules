# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Bootstrap dependencies (first time or after `requirements.psd1` changes):
```powershell
.\build.ps1 -Bootstrap
```

Build (compiles module to `Output/`):
```powershell
.\build.ps1
```

Run all tests:
```powershell
.\build.ps1 -Task Test
```

Run a single test file:
```powershell
.\build.ps1 -Task Build
Invoke-Pester -Path .\tests\Measure-TODOComment.tests.ps1
```

List available tasks:
```powershell
.\build.ps1 -Help
```

Spell check:
```powershell
cspell lint "**/*.ps1" "**/*.md"
```

## Architecture

This is a **PSScriptAnalyzer custom rules module**. The build uses `psake` → `PowerShellBuild`, which compiles all `Public/*.ps1` files into a single monolithic `GoodEnoughRules.psm1` in `Output/<version>/`.

**Tests run against the compiled `Output/` module**, not the source files. Always build before running tests.

### Rule conventions

Each rule lives in `GoodEnoughRules/Public/Measure-<Name>.ps1` and exports one function named `Measure-<Name>`.

PSScriptAnalyzer custom rules come in two shapes:

- **AST rules** — parameter type is an AST node (e.g., `[ScriptBlockAst]`). PSScriptAnalyzer calls the rule once per matching node.
- **Token rules** — parameter type is `[System.Management.Automation.Language.Token[]]`. PSScriptAnalyzer passes **all tokens as a single array** in one call. The rule must iterate over `$Token` internally with `foreach ($tok in $Token)`.

> **Important:** Token rules receive `Token[]` from `Invoke-ScriptAnalyzer`, but tests that call the function directly (e.g., `$tokens | ForEach-Object { Measure-X -Token $_ }`) pass one token per call. The `foreach ($tok in $Token)` pattern handles both.

Rules return `[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]` objects via hashtable constructor with keys: `Message`, `Extent`, `RuleName` (`$PSCmdlet.MyInvocation.InvocationName`), `Severity` (`'Error'`, `'Warning'`, or `'Information'`).

### Tests

Each rule has a corresponding `tests/Measure-<Name>.tests.ps1`. Tests use Pester 5 and follow these patterns:

- **Inline token tests** — parse a fake script string with `[Parser]::ParseInput(...)`, pipe tokens to the rule function directly, assert on the result.
- **Path tests** — use `Invoke-ScriptAnalyzer -Path` with `CustomRulePath` pointing to `$script:outputModVerModule` (the compiled `.psm1`). Fixture files live in `tests/fixtures/`.
- **Suppression test** — a fixture file with `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-RuleName', '')]` on a function; run via `Invoke-ScriptAnalyzer -Path` and assert empty result.
- **`-ForEach` cases** — use hashtable entries (`@{ Key = Value }`) so test names interpolate as `'Detects <Description>'`.

### Docs

`docs/en-US/Measure-<Name>.md` — PlatyPS-style help. Kept in sync with the function's comment-based help.
