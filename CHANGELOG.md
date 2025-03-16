# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

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
