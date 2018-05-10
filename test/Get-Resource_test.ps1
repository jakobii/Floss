Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


Get-Resource -ID 'dbwh-01' -Path "C:\temp\resources.json"





