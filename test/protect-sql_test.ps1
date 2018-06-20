Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"

# char array
[array]$arr = $("lk'").ToCharArray()
$escaped = protect-sql $arr
Assert-String -InputObject $escaped[0] -Expect "l" -Tag 'char Array'
Assert-String -InputObject $escaped[1] -Expect "k" -Tag 'char Array'
test-falsy $escaped[3] -af | Assert-boolean -Expect $false -Tag 'char Array'


# string array
[array]$arr = @("O'Brian","Alex's")
$escaped = protect-sql $arr
Assert-String -InputObject $escaped[0] -Expect "O''Brian" -Tag 'String Array'
Assert-String -InputObject $escaped[1] -Expect "Alex''s" -Tag 'String Array' 

# string
$escaped = protect-sql "O'Brian"
Assert-String -InputObject $escaped -Expect "O''Brian" -Tag 'String' 

