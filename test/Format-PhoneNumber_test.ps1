#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"


Format-PhoneNumber '3as3$@#344.()4#@!4' | Assert-String -Expect '333-4444' -Tag "Bad Character Removeral"
Format-PhoneNumber '334444' | Assert-String -Expect '334444' -tag "Non-formatted PhoneNumber"
Format-PhoneNumber '3334444' | Assert-String -Expect '333-4444' -Tag "Short Formatted PhoneNumber"
Format-PhoneNumber '2223334444' | Assert-String -Expect '(222) 333-4444' -Tag "Formatted PhoneNumber with Area code"
Format-PhoneNumber '12223334444' | Assert-String -Expect '+1 (222) 333-4444' -Tag "Formatted PhoneNumber with 1d Country code"
Format-PhoneNumber '112223334444' | Assert-String -Expect '+11 (222) 333-4444' -Tag "Formatted PhoneNumber with 2d Country code"
Format-PhoneNumber '1112223334444' | Assert-String -Expect '+111 (222) 333-4444' -Tag "Formatted PhoneNumber with 3d Country code"
