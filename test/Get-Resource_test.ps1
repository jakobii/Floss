Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


Get-Resource -id 'dbwh' -Path "C:\temp\resources.json"





