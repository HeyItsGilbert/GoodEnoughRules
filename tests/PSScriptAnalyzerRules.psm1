$rules = Import-Module "$PSScriptRoot\..\Output\GoodEnoughRules" -PassThru
Export-ModuleMember -Function @($rules.ExportedCommands.Keys)
