Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"



FUNCTION test-recurse ($value) {

    if ($value -is [array]) {
        [array]$blah = @()
        foreach ($item in $value) {
            $index = test-recurse $item
            $blah.Add($index)
        }
        RETURN $blah
    }
    if ($value -is [char]){
        Write-Host $value
    }


}

[char]$char1 = 'a'
[char]$char2 = "b"

[array]$array = @($char2 , $char1 ) 



test-recurse $array