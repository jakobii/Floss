Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"

$int = Format-Date -InputObject $(Get-Date -Date '1/1/2018')
Assert-String -InputObject $int -Expect '1/1/2018' -Tag 'Small Date'







