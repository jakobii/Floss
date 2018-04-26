Import-Module "$PSScriptRoot\..\util\Assert.psm1"
Import-Module "$PSScriptRoot\ProperName.psm1"


[string]$name = Format-ProperName -Value "o'brian"
Assert-String -Value $name -Expect "O''Brian" -Tag "Irish Name"


[string]$name = Format-ProperName -Value "o'brian. jr."
Assert-String -Value $name -Expect "O''Brian" -Tag "Irish Name with Jr"

[string]$name = Format-ProperName -Value "mcdonald.sr"
Assert-String -Value $name -Expect "McDonald" -Tag "McName Name with Sr"

[string]$name = Format-ProperName -Value "o'brian IV"
Assert-String -Value $name -Expect "O''Brian" -Tag "Irish Name with roman numerals"



[string]$name = Format-ProperName -Value "()*&#$%^&*#@#&)(*&{}|\$^$"
Assert-String -Value $name -Expect "" -Tag "Special Char Removal"


# [fix] unlikely sonario but still...
[string]$name = Format-ProperName -Value "''''''''''"
Assert-String -Value $name -Expect "" -Tag "only single quotes"


# [fix] unlikely sonario but still...
[string]$name = Format-ProperName -Value 'jacob ochoa'
Assert-String -Value $name -Expect "Jacob Ochoa" -Tag "fn ln"
