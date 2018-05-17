Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


[string]$name = Format-ProperName -InputObject "o'bRiAn"
Assert-String -InputObject $name -Expect "O''Brian" -Tag "Irish Name"


[string]$name = Format-ProperName -InputObject "o'brian. jr."
Assert-String -InputObject $name -Expect "O''Brian" -Tag "Irish Name with suffix Jr"

[string]$name = Format-ProperName -InputObject "mcdonald.sr"
Assert-String -InputObject $name -Expect "McDonald" -Tag "McName Name with suffix Sr"

[string]$name = Format-ProperName -InputObject "o'brian IV"
Assert-String -InputObject $name -Expect "O''Brian" -Tag "Irish Name with suffix in roman numerals"



[string]$name = Format-ProperName -InputObject "()*&#$%^&*#@#&)(*&{}|\$^$"
Assert-String -InputObject $name -Expect "" -Tag "Special Char Removal"


# [fix] unlikely sonario but still...
[string]$name = Format-ProperName -InputObject "''''''''''"
Assert-String -InputObject $name -Expect "" -Tag "only single quotes, still broken.."


# [fix] unlikely sonario but still...
[string]$name = Format-ProperName -InputObject 'jAcOb OcHoA'
Assert-String -InputObject $name -Expect "Jacob Ochoa" -Tag "fn ln"
