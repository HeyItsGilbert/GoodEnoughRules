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
    It 'Detects <_> comment' -ForEach @(
        'TODO',
        'todo',
        'FIXME',
        'fixme',
        'BUG',
        'bug',
        'MARK',
        'mark'
    ) {
        $fakeScript = @"
Write-Host 'Hello, World!' # $_
"@
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
        $result = Measure-TODOComment -ScriptBlockAst $ast
        $result.Count | Should -BeExactly 1
        $result[0].Message | Should -Be 'TODO comment found. Please consider removing it or tracking with issue.'
    }

    It 'Detects checkbox style comment "<_>"' -ForEach @(
        '[ ]',
        '[!]',
        '[?]',
        '[*]',
        '[-]'
    ) {
        $fakeScript = @"
# $($_) We should write Hello, World! more often!
Write-Host 'Hello, World!'
"@
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($fakeScript, [ref]$null, [ref]$null)
        $result = Measure-TODOComment -ScriptBlockAst $ast
        $result.Count | Should -BeExactly 1
        $result[0].Message | Should -Be 'TODO comment found. Please consider removing it or tracking with issue.'
    }
}
