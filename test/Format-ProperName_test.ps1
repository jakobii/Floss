#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"

Format-ProperName "o'bRiAn" | Assert-String -Expect "O'Brian" -Tag "Irish Name"

Format-ProperName "o'brian. jr." | Assert-String -Expect "O'Brian" -Tag "Irish Name with suffix Jr"

Format-ProperName "mcdonald.sr" | Assert-String -Expect "McDonald" -Tag "McName Name with suffix Sr"

Format-ProperName "o'brian IV" | Assert-String -Expect "O'Brian" -Tag "Irish Name with suffix in roman numerals"

Format-ProperName "()*&#$%^&*#@#&)(*&{}|\$^$" | Assert-String -Expect $null -Tag "Special Char Removal"

'jAcOb OcHoA' | Format-ProperName | Assert-String -Expect "Jacob Ochoa" -Tag "fn ln on the pipeline"
