Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"

Get-KeyChain -ID '' -Verbosely
Get-KeyChain -Group '' -Member '' -Verbosely




