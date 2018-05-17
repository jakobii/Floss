#unit

import-module "$PSScriptRoot\..\inquiry.psm1"

Function Get-foo () {
    Get-FunctionName
}

Get-foo | Assert-String -Expect 'Get-foo' -Tag 'parent function'




