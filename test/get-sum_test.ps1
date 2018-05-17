
import-module "$PSScriptRoot\..\inquiry.psm1"



$sum = get-sum 12345667,1098273546,8927309847

Assert-String -InputObject $sum -Expect '10037929060' -Tag 'Sum of array'