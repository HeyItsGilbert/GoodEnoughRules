Describe 'Measure-InvokeWebRequestWithoutBasic' {
    BeforeAll {
        if ( -not $env:BHPSModuleManifest ) {
            Set-BuildEnvironment -Path "$PSScriptRoot\.." -Force
        }
        $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'Output'
        $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
        $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
        $script:outputModVerModule = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psm1"
        $outputModVerManifest = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1"

        # Get module commands
        # Remove all versions of the module from the session. Pester can't handle multiple versions.
        Get-Module $env:BHProjectName | Remove-Module -Force -ErrorAction Ignore
        Import-Module -Name $outputModVerManifest -Verbose:$false -ErrorAction Stop
        Import-Module -Name 'PSScriptAnalyzer' -Verbose:$false -ErrorAction Inquire
    }

    Context 'When Invoke-WebRequest is used without UseBasicParsing' {
        It 'Detects Invoke-WebRequest without UseBasicParsing' {
            $fakeScript = @"
Invoke-WebRequest -Uri 'https://example.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
            $result[0].Severity | Should -Be 'Error'
        }

        It 'detects Invoke-WebRequest without UseBasicParsing in different formatting' {
            $file = "$PSScriptRoot\fixtures\ExampleFunction.ps1"
            $invokeScriptAnalyzerSplat = @{
                Path = $file
                IncludeRule = 'Measure-InvokeWebRequestWithoutBasic'
                CustomRulePath = $script:outputModVerModule
            }

            $result = Invoke-ScriptAnalyzer @invokeScriptAnalyzerSplat
            $result.Count | Should -BeExactly 2
            $result[0].Message | Should -Be 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
            $result[0].Severity | Should -Be 'Error'
            $result[0].Line | Should -Be 6
            $result[1].Message | Should -Be 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
            $result[1].Severity | Should -Be 'Error'
        }

        It 'Detects iwr alias without UseBasicParsing' {
            $fakeScript = @"
iwr -Uri 'https://example.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
        }

        It 'Detects curl alias without UseBasicParsing' {
            $fakeScript = @"
curl 'https://example.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be 'Invoke-WebRequest should be used with the UseBasicParsing parameter.'
        }

        It 'Does not detect curl.exe usage' {
            $fakeScript = @"
curl.exe 'https://example.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -Be 0
        }
    }

    Context 'When Invoke-WebRequest is used with UseBasicParsing' {
        It 'Does not flag Invoke-WebRequest with UseBasicParsing' {
            $fakeScript = @"
Invoke-WebRequest -Uri 'https://example.com' -UseBasicParsing
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -Be 0
        }

        It 'Does not flag iwr alias with UseBasicParsing' {
            $fakeScript = @"
iwr -Uri 'https://example.com' -UseBasicParsing
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -Be 0
        }
    }

    Context 'Multiple commands in script' {
        It 'Detects multiple violations in same script' {
            $fakeScript = @"
Invoke-WebRequest -Uri 'https://example.com'
iwr 'https://test.com'
curl 'https://another.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -BeExactly 3
        }

        It 'Does not flag non-Invoke-WebRequest commands' {
            $fakeScript = @"
Write-Host 'Hello, World!'
Get-Process
Invoke-RestMethod -Uri 'https://example.com'
"@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-InvokeWebRequestWithoutBasic -ScriptBlockAst $ast
            $result.Count | Should -Be 0
        }
    }
}
