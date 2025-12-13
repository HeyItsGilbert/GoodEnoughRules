Describe 'Measure-TODOComment' {
    BeforeAll {
        if ( -not $env:BHPSModuleManifest ) {
            .\build.ps1 -Task Build -Verbose
        }
        $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'Output'
        $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
        $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
        $outputModVerManifest = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1"

        # Get module commands
        # Remove all versions of the module from the session. Pester can't handle multiple versions.
        Get-Module $env:BHProjectName | Remove-Module -Force -ErrorAction Ignore
        Import-Module -Name $outputModVerManifest -Verbose:$false -ErrorAction Stop
        Import-Module -Name 'PSScriptAnalyzer' -Verbose:$false -ErrorAction Inquire
    }
    Context 'Method usage with Invoke-WebRequest and UseBasicParsing' {
        It 'Detects bad method usage' {
            $fakeScript = '$bar = (iwr -Uri https://example.com -UseBasicParsing).Forms'
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-BasicWebRequestProperty -ScriptBlockAst $ast
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be "Invoke-WebRequest cannot use the 'Forms' parameter when 'UseBasicParsing' is specified."
        }

        It 'does not detect correct usage of Images property' {
            $fakeScript = '$bar = (iwr -Uri https://example.com -UseBasicParsing).Images'
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-BasicWebRequestProperty -ScriptBlockAst $ast
            $result | Should -BeNullOrEmpty
        }
    }
    Context 'Assignment usage with Invoke-WebRequest and UseBasicParsing' {
        It 'Does detect usage of incompatible properties after assignment' {
            $fakeScript = @'
            $foo = Invoke-WebRequest -Uri https://example.com -UseBasicParsing
            $foo.Forms # Not valid with UseBasicParsing
'@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-BasicWebRequestProperty -ScriptBlockAst $ast
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be "Invoke-WebRequest cannot use the 'Forms' parameter when 'UseBasicParsing' is specified."
        }
        It 'Does detect usage of incompatible properties after assignment' {
            $fakeScript = @'
            $foo = Invoke-WebRequest -Uri https://example.com -UseBasicParsing
            $bar = $foo.Forms # Not valid with UseBasicParsing
'@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-BasicWebRequestProperty -ScriptBlockAst $ast
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -BeExactly 1
            $result[0].Message | Should -Be "Invoke-WebRequest cannot use the 'Forms' parameter when 'UseBasicParsing' is specified."
        }
        It 'Does not detect assignments of Invoke-WebRequest with UseBasicParsing' {
            $fakeScript = @'
            $foo = Invoke-WebRequest -Uri https://example.com -UseBasicParsing
            $foo.Images # This is allowed
'@
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
            $result = Measure-BasicWebRequestProperty -ScriptBlockAst $ast
            $result | Should -BeNullOrEmpty
        }
    }
}
