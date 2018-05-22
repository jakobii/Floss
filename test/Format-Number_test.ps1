#unit


import-module "$PSScriptRoot\..\inquiry.psm1"


Format-Number '6]$]543j[#2sft1o(9;87' | Assert-String -Expect '654321987' -Tag 'Num, letters, chars'







