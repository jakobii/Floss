#unit


import-module "$PSScriptRoot\..\inquiry.psm1"

Format-Date $(Get-Date -Date '1/1/2018') | Assert-String -Expect '1/1/2018' -Tag 'Small Date'








