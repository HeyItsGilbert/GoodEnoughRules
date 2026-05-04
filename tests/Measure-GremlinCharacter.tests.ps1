Describe 'Measure-GremlinCharacter' {
    BeforeAll {
        if (-not $env:BHPSModuleManifest) {
            Set-BuildEnvironment -Path "$PSScriptRoot\.." -Force
        }
        $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'Output'
        $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
        $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
        $script:outputModVerModule = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psm1"
        $outputModVerManifest = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1"

        Get-Module $env:BHProjectName | Remove-Module -Force -ErrorAction Ignore
        Import-Module -Name $outputModVerManifest -Verbose:$false -ErrorAction Stop
        $script:fixturesDir = Join-Path -Path $PSScriptRoot -ChildPath 'fixtures'
    }

    It 'Detects <Description> (U+<CodePoint>)' -ForEach @(
        @{ Char = [char]0x0003; CodePoint = '0003'; Description = 'end of text'; Severity = 'Warning' }
        @{ Char = [char]0x000B; CodePoint = '000B'; Description = 'line tabulation'; Severity = 'Warning' }
        @{ Char = [char]0x00A0; CodePoint = '00A0'; Description = 'non-breaking space'; Severity = 'Information' }
        @{ Char = [char]0x00AD; CodePoint = '00AD'; Description = 'soft hyphen'; Severity = 'Information' }
        @{ Char = [char]0x200B; CodePoint = '200B'; Description = 'zero width space'; Severity = 'Error' }
        @{ Char = [char]0x200C; CodePoint = '200C'; Description = 'zero width non-joiner'; Severity = 'Warning' }
        @{ Char = [char]0x200E; CodePoint = '200E'; Description = 'left-to-right mark'; Severity = 'Error' }
        @{ Char = [char]0x2013; CodePoint = '2013'; Description = 'en dash'; Severity = 'Warning' }
        @{ Char = [char]0x2018; CodePoint = '2018'; Description = 'left single quotation mark'; Severity = 'Warning' }
        @{ Char = [char]0x2019; CodePoint = '2019'; Description = 'right single quotation mark'; Severity = 'Warning' }
        @{ Char = [char]0x201C; CodePoint = '201C'; Description = 'left double quotation mark'; Severity = 'Warning' }
        @{ Char = [char]0x201D; CodePoint = '201D'; Description = 'right double quotation mark'; Severity = 'Warning' }
        @{ Char = [char]0x2029; CodePoint = '2029'; Description = 'paragraph separator'; Severity = 'Error' }
        @{ Char = [char]0x2066; CodePoint = '2066'; Description = 'left-to-right isolate'; Severity = 'Error' }
        @{ Char = [char]0x2069; CodePoint = '2069'; Description = 'pop directional isolate'; Severity = 'Error' }
        @{ Char = [char]0x202C; CodePoint = '202C'; Description = 'pop directional formatting'; Severity = 'Error' }
        @{ Char = [char]0x202D; CodePoint = '202D'; Description = 'left-to-right override'; Severity = 'Error' }
        @{ Char = [char]0x202E; CodePoint = '202E'; Description = 'right-to-left override'; Severity = 'Error' }
        @{ Char = [char]0xFFFC; CodePoint = 'FFFC'; Description = 'object replacement character'; Severity = 'Error' }
    ) {
        $fakeScript = "Write-Host '${Char}hello'"
        $tokens = $null
        [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$tokens, [ref]$null) | Out-Null
        $result = $tokens | ForEach-Object { Measure-GremlinCharacter -Token $_ }
        $result.Count | Should -BeExactly 1
        $result[0].Message | Should -Be "Gremlin character found: U+${CodePoint} (${Description}). This character may be invisible or visually deceptive."
        $result[0].Severity | Should -Be $Severity
    }

    It 'Does not flag clean code' {
        $fakeScript = "Write-Host 'Hello, World!'"
        $tokens = $null
        [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$tokens, [ref]$null) | Out-Null
        $result = $tokens | ForEach-Object { Measure-GremlinCharacter -Token $_ }
        $result | Should -BeNullOrEmpty
    }

    It 'Can be suppressed with SuppressMessageAttribute' {
        $invokeScriptAnalyzerSplat = @{
            Path = "$script:fixturesDir\GremlinSuppressed.ps1"
            IncludeRule = 'Measure-GremlinCharacter'
            CustomRulePath = $script:outputModVerModule
        }
        $result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat
        $result | Should -BeNullOrEmpty
    }

    It 'Can Detect on Path' {
        $invokeScriptAnalyzerSplat = @{
            Path = "$script:fixturesDir\Gremlin.ps1"
            IncludeRule = 'Measure-GremlinCharacter'
            CustomRulePath = $script:outputModVerModule
        }
        $result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat
        $result.Count | Should -BeExactly 1
        $result[0].Message | Should -Be "Gremlin character found: U+2013 (en dash). This character may be invisible or visually deceptive."
    }
}
