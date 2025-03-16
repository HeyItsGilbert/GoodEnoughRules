Describe 'Measure-TODOComment' {
    BeforeAll {
        $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'Output'
        $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
        $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
        $outputModVerManifest = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1"

        # Get module commands
        # Remove all versions of the module from the session. Pester can't handle multiple versions.
        Get-Module $env:BHProjectName | Remove-Module -Force -ErrorAction Ignore
        Import-Module -Name $outputModVerManifest -Verbose:$false -ErrorAction Stop
    }
    It 'Detects missing key' {
        $fakeScript = @'
$secureString = 'Hello, World!' | ConvertTo-SecureString -AsPlainText -Force
ConvertFrom-SecureString -SecureString $secureString
'@
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
        $result = Measure-TODOComment -ScriptBlockAst $ast
        $result.Count | Should -BeExactly 1
        $result[0].Message | Should -Be 'ConvertFrom-SecureString should be used with a Key.'
    }

    It 'does not detect correct usage' {
        $fakeScript = @'
$secureString = 'Hello, World!' | ConvertTo-SecureString -AsPlainText -Force
ConvertFrom-SecureString -SecureString $secureString -Key (1..16)
'@
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
        $result = Measure-TODOComment -ScriptBlockAst $ast
        $results | Should -BeNullOrEmpty
    }
}
