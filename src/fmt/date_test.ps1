Import-Module "$psscriptroot\date.psm1"
Import-Module "$PSScriptRoot\..\util\Assert.psm1"



$int = Format-Date -value $(Get-Date -Date '1/1/2018')
Assert-String -Value $int -Expect '1/1/2018' -Tag 'Small Date'







