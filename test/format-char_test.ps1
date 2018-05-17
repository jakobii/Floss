Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"

$char = format-char '   great'
Assert-String -InputObject $char -Expect 'g' -tag "first character of string, ingnore spaces"



$char = format-char 'w'
Assert-String -InputObject $char -Expect 'w' -tag "single char"








