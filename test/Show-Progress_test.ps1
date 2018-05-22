
import-module "$PSScriptRoot\..\inquiry.psm1" -Verbose

$max = 10000

for ($i = 0; $i -lt $max; $i++) {
    
    Show-Progress -Goal $max -step $I -Tag "Testing The Show-Progress Function"  -id 30

}






