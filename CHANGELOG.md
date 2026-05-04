# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.4.0] 2026-05-04

### Added

- `Measure-GremlinCharacter`: New rule to detect invisible or visually
  deceptive Unicode characters (gremlins) such as zero-width spaces,
  bidirectional overrides, and curly quotes. 19 characters flagged with
  per-character severity (`Error`, `Warning`, or `Information`).
  Inspired by [vscode-gremlins](https://github.com/nhoizey/vscode-gremlins).
- Tests for `Measure-GremlinCharacter` with per-character `-ForEach`
  cases, a negative clean-code case, a fixture-based detection test,
  and a suppression test using `SuppressMessageAttribute`.
- `CLAUDE.md` with project guidance for Claude Code.

### Changed

- `Measure-TODOComment`: Updated `Token` parameter type to `Token[]`
  to match how PSScriptAnalyzer invokes token-based rules; renamed
  `$matches` to `$regexMatches` to avoid collision with the automatic
  `$Matches` variable; normalized keyword casing to lowercase.
- `tests/PSScriptAnalyzerRules.psm1`: Proxy module now loads explicitly
  from the `Output\GoodEnoughRules` build directory.

## [0.3.1] 2025-12-14

### Fixed

- `Measure-BasicWebRequestProperty`: AST search modified to fix duplicate errors
  due to recursive search.
- `Measure-InvokeWebRequestWithoutBasic`: AST search modified to fix duplicate
  errors due to recursive search.

## [0.3.0] 2025-12-13

### Added

- `Measure-BasicWebRequestProperty`: Detects when `Invoke-WebRequest` uses
  `UseBasicParsing` with incompatible properties like `Forms`, `ParsedHtml`,
  `Scripts`, or `AllElements`. Works with both direct property access and
  variable assignments.
- `Measure-InvokeWebRequestWithoutBasic`: Flags `Invoke-WebRequest` (and its
  aliases `iwr`, `curl`) when used without the `UseBasicParsing` parameter.
- `Get-CommandParameter`: New private helper function to parse command
  parameters from AST, including support for positional parameters.
- Documentation for new rules in `docs/en-US/` directory.
- Comprehensive test coverage for new rules.

### Changed

- Updated `about_GoodEnoughRules.help.md` with complete module documentation
  including examples, rule descriptions, and troubleshooting guidance.
- `Measure-SecureStringWithKey`: Standardized parameter block formatting and
  updated to use `Get-CommandParameter` helper function.
- Test files: Added BeforeAll checks to ensure module builds before testing.
- Improved code consistency across all rule files (param block formatting,
  using consistent helper function names).

## [0.2.0] Measure-SecureStringWithKey

### Added

- `Measure-SecureStringWithKey` now check if `ConvertFrom-SecureString` is used
  without a `-Key` parameter. If you don't use a key then it's use the DPAPI
  which means the secret is user and machine bound.

### Changes

- Perf improvements to `Measure-TODOComment` ([#3]).

## [0.1.1] Use Tokens

### Changes

- `Measure-TODOComment` now uses
  `[System.Management.Automation.Language.Token]` to find comments. This makes
  it so it only highlights the comment!

## [0.1.0] Initial Release

### Added

- `Measure-TODOComment` is a PSScriptAnalyzer rule to detect if a TODO style
  comment exists in your code.

[#3]: https://github.com/HeyItsGilbert/GoodEnoughRules/pull/3

<!-- spell-checker:ignore DPAPI -->
