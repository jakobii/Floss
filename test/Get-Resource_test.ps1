Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"


Get-Resource -ID 'dbwh-01' -Path "C:\temp\resources.json"





