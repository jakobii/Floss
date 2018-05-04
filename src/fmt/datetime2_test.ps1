Import-Module "$psscriptroot\datetime2.psm1"
Import-Module "$PSScriptRoot\..\util\Assert.psm1"



$int = Format-Datetime2 -value $(Get-Date -Date '2018-04-05 16:28:59.7100000')
Assert-String -Value $int -Expect '2018-4-5 16:28:59.7100000' -Tag 'Datetime2'


