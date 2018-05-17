#unit

import-module "$PSScriptRoot\..\inquiry.psm1"

# Sr & Jr
Format-Suffix "Jacob Ochoa Jr" | Assert-String -Expect 'Jr' -Tag 'suffix jr'
Format-Suffix "Jacob Ochoa, jr" | Assert-String -Expect "Jr" -Tag 'suffix comma jr'
Format-Suffix "Jacob Ochoa JR." | Assert-String -Expect 'Jr' -Tag 'suffix jr period'
Format-Suffix "Jacob Ochoa, JR." | Assert-String  -Expect 'Jr' -Tag 'suffix comma jr period'
Format-Suffix "Jacob Ochoa SR" | Assert-String -Expect 'Sr' -Tag 'suffix sr'
Format-Suffix "Jacob Ochoa, sR" | Assert-String -Expect 'Sr' -Tag 'suffix comma sr'
Format-Suffix "Jacob Ochoa SR." | Assert-String -Expect 'Sr' -Tag 'suffix sr period'
Format-Suffix "Jacob Ochoa, sr." | Assert-String -Expect 'Sr' -Tag 'suffix comma sr period'


# Roman Numberals 1-13
Format-Suffix "Jacob Ochoa, II." | Assert-String -Expect 'II' -Tag 'Roman Numberal 2'
Format-Suffix "Jacob Ochoa, III." | Assert-String -Expect 'III' -Tag 'Roman Numberal 3'
Format-Suffix "Jacob Ochoa, IV." | Assert-String -Expect 'IV' -Tag 'Roman Numberal 4'
Format-Suffix "Jacob Ochoa, V." | Assert-String -Expect 'V' -Tag 'Roman Numberal 5'
Format-Suffix "Jacob Ochoa, VI." | Assert-String -Expect 'VI' -Tag 'Roman Numberal 6'
Format-Suffix "Jacob Ochoa, VII." | Assert-String -Expect 'VII' -Tag 'Roman Numberal 7'
Format-Suffix "Jacob Ochoa, VIII." | Assert-String -Expect 'VIII' -Tag 'Roman Numberal 8'
Format-Suffix "Jacob Ochoa, IX." | Assert-String -Expect 'IX' -Tag 'Roman Numberal 9'
Format-Suffix "Jacob Ochoa, X." | Assert-String -Expect 'X' -Tag 'Roman Numberal 10'
Format-Suffix "Jacob Ochoa, XI." | Assert-String -Expect 'XI' -Tag 'Roman Numberal 11'
Format-Suffix "Jacob Ochoa, XII." | Assert-String -Expect 'XII' -Tag 'Roman Numberal 12'
Format-Suffix "Jacob Ochoa, XIII." | Assert-String -Expect 'XIII' -Tag 'Roman Numberal 13'






