Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


New-Path -Path "C:\temp\rar\blah.csv" -Verbosely -ExcludeFile