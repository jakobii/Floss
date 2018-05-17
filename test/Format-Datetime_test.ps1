#unit


import-module "$PSScriptRoot\..\inquiry.psm1"


Format-Datetime $(Get-Date -Date '2018-04-05 16:28:59.710') | Assert-String -Expect '2018-4-5 16:28:59' -Tag 'Datetime'




