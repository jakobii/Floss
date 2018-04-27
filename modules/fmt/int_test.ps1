Import-Module "$psscriptroot\int.psm1"
Import-Module "$PSScriptRoot\..\util\Assert.psm1"



$int = Format-Int -value '6]$]543j[#2sft1o(9;87'
Assert-String -Value $int -Expect '654321987' -Tag 'Num, letters, chars'







