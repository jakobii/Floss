#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"

Function Get-foo () {
    Get-FunctionName
}

Get-foo | Assert-String -Expect 'Get-foo' -Tag 'parent function'




