Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"

Function foo-Bar () {
    write-host $(Get-FunctionName)
}

foo-Bar



