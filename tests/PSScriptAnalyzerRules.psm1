$rules = Import-Module -Name 'GoodEnoughRules' -PassThru
Export-ModuleMember -Function @($rules.ExportedCommands.Keys)
