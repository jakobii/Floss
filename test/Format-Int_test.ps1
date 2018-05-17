Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


Format-Int '6]$]543j[#2sft1o(9;87' | Assert-String -Expect '654321987' -Tag 'Num, letters, chars'







