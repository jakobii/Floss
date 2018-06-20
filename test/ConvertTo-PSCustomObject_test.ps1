#unit





import-module "$PSScriptRoot\..\inquiry.psm1"


$array = @( 
    
    # ordered
    [ordered] @{
        a = '9/4/2018' | convertTo-Type -type 'datetime' 
        b = '652.8567' | convertTo-Type -type 'double' 
    },

    # non ordered
    @{
        a = '9/3/2018' | convertTo-Type -type 'datetime' 
        b = '203948.102938' | convertTo-Type -type 'double' 
    }
)
$blah = @()
foreach ($hash in $array) {

    [array]$blah += ConvertTo-PSCustomObject $hash

}

# out csv works too!
# $blah | Export-Csv -Path 'C:\temp\blah.csv' -NoTypeInformation

$blah[0] | Assert-type -Expect 'System.Management.Automation.PSCustomObject' -tag 'PSCustomObject'

$blah[0].a | Assert-type  -Expect 'datetime' -tag 'PSCustomObject child a'

