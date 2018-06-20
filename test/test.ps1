
import-module "$PSScriptRoot\..\inquiry.psm1"


Test-Falsy @($null, 0, '     ', [dbnull]::value )

Test-Falsy @{num = 1; txt='some text'}


$n = 123 | ConvertTo-Type double
$n.gettype()

Format-EmailAddress 'bad data some.complex_name@sub.domain.com more bad data?' 

Get-Type @('an','array')


Test-Falsy @($null, $null, $null )