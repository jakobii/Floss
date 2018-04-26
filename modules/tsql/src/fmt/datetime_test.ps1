Import-Module "$psscriptroot\datetime.psm1"
Import-Module "$PSScriptRoot\..\util\Assert.psm1"



$int = Format-Datetime -value $(Get-Date -Date '2018-04-05 16:28:59.710')
Assert-String -Value $int -Expect '2018-4-5 16:28:59' -Tag 'Datetime'




