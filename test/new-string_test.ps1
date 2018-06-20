


import-module "$PSScriptRoot\..\inquiry.psm1"

$Hashtable = @{
    hrId = 'blah'
    fn   = 'omG'
}

$array = @('a','b','c')



$Hashtable | new-String | Assert-String -Expect 'blahomG' -Tag 'concat hashtable'
,$array | new-String | Assert-String -Expect 'abc' -Tag 'concat array'

