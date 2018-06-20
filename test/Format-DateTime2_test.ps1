#unit

Import-Module "$PSScriptRoot\..\Inquiry.src.psm1"


$(Get-Date -Date '2018-04-05 16:28:59.7100000') | Format-Datetime2 | Assert-String -Expect '2018-4-5 16:28:59.7100000' -Tag 'Sql Server Datetime2'


