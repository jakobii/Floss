Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


[string]$ph7 = Format-PhoneNumber -Value '3as3$@#344.()4#@!4'
Assert-String -InputObject $ph7 -Expect '333-4444' -Tag "Bad Character Removeral"

$ph6 = Format-PhoneNumber -Value '334444'
Assert-String -InputObject $ph6 -Expect '334444' -tag "Non-formatted PhoneNumber"

[string]$ph7 = Format-PhoneNumber -Value '3334444'
Assert-String -InputObject $ph7 -Expect '333-4444' -Tag "Short Formatted PhoneNumber"

$ph10 = Format-PhoneNumber -Value '2223334444'
Assert-String -InputObject $ph10 -Expect '(222) 333-4444' -Tag "Formatted PhoneNumber with Area code"

$ph11 = Format-PhoneNumber -Value '12223334444'
Assert-String -InputObject $ph11 -Expect '+1 (222) 333-4444' -Tag "Formatted PhoneNumber with 1d Country code"

$ph12 = Format-PhoneNumber -Value '112223334444'
Assert-String -InputObject $ph12 -Expect '+11 (222) 333-4444' -Tag "Formatted PhoneNumber with 2d Country code"

$ph12 = Format-PhoneNumber -Value '1112223334444'
Assert-String -InputObject $ph12 -Expect '+111 (222) 333-4444' -Tag "Formatted PhoneNumber with 3d Country code"
