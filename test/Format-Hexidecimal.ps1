
import-module "$PSScriptRoot\..\inquiry.psm1"


Format-Hexidecimal -InputObject '123' 
#Assert-String -Expect '654321987' -Tag 'Num, letters, chars'

[convert]::ToUInt16(123)