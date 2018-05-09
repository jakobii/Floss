Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


$int = Format-Datetime -value $(Get-Date -Date '2018-04-05 16:28:59.710')
Assert-String -InputObject $int -Expect '2018-4-5 16:28:59' -Tag 'Datetime'




