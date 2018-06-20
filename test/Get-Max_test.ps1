#unit
import-module "$PSScriptRoot\..\Inquiry.src.psm1"

$max = get-max 298374982374,928374,354123
Assert-String -InputObject $max -Expect '298374982374' -Tag 'max of array'