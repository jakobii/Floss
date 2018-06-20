Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"



$bool = test-falsy -o $null 
Assert-Boolean -InputObject $bool -Expect $true -Tag 'null'

$bool = test-falsy -o '       ' 
Assert-Boolean -InputObject $bool -Expect $true -Tag 'empty string'


$bool = test-falsy -o '  ;laksjdf     ' 
Assert-Boolean -InputObject $bool -Expect $false -Tag 'not empty string'


$bool = test-falsy -o '  ;laksjdf     ' -af
Assert-Boolean -InputObject $bool -Expect $true -Tag 'not empty string as false'


[char]$char = ' '
$bool = test-falsy -o $char 
Assert-Boolean -InputObject $bool -Expect $true -Tag 'empty char'


